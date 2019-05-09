Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA16718DDB
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfEIQR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:17:57 -0400
Received: from drutsystem.com ([84.10.39.251]:51756 "EHLO drutsystem.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbfEIQR5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 12:17:57 -0400
To:     linux-netdev <netdev@vger.kernel.org>
From:   Michal Soltys <soltys@ziu.info>
Subject: [question] rp_filter=1 ~implies arp_filter
Message-ID: <4577a5aa-0d95-accd-f581-e1f25b0fcd68@ziu.info>
Date:   Thu, 9 May 2019 18:17:48 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-MailScanner-ID: 9485572A0B3.AFDA1
X-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: soltys@ziu.info
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This got me a bit surprised actually and I'm wondering if it's intended. 
While both options are somewhat similar in their function, they do 
different things after all (and for different protocols):

- arp_filter - whether all interfaces should consider responding for arp 
request (which then can be further tuned by arp_ignore whether they 
actually should reply)

- rp_filter (=1) - will discard ip packets incoming on interface that is 
not considered the best

But it seems rp_filter (=1) also either nukes arp or inhibits arp reply. 
For example:

::In 1st namespace:

a2    inet 192.168.77.88/24 scope global a2
b2    inet 192.168.77.89/24 scope global b2

192.168.77.0/24 dev b2 proto kernel scope link src 192.168.77.89
192.168.77.0/24 dev a2 proto kernel scope link src 192.168.77.88 metric 20

So 77.89 is "better" in route context.

rp_filter=1
arp_filter=0
arp_ignore=1

::In 2nd namespace:

a1 and b1 enslaved to bridge brX with address 192.168.77.77/24

In such scenario, doing from this namespace:

arping -b -I brX 192.168.77.89 - works as expected with replies from 
192.168.77.89's interface

arping -b -I brX 192.168.77.88 - nothing

Setting arp_ignore=0 (in 1st namespace) would (as expected) give replies 
in both cases from 192.168.77.89's interface only.
