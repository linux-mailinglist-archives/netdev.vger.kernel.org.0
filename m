Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664D72F8F8
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 11:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfE3JHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 05:07:16 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:40103 "EHLO
        cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfE3JHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 05:07:15 -0400
X-Greylist: delayed 1924 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 May 2019 05:07:15 EDT
Received: from pannekake.samfundet.no ([2001:67c:29f4::50])
        by cassarossa.samfundet.no with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sesse@samfundet.no>)
        id 1hWGWi-00037R-Gc; Thu, 30 May 2019 10:35:08 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.92)
        (envelope-from <sesse@samfundet.no>)
        id 1hWGWi-0002dZ-Cj; Thu, 30 May 2019 10:35:08 +0200
Date:   Thu, 30 May 2019 10:35:08 +0200
From:   "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
To:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc:     netdev@vger.kernel.org
Subject: EoGRE sends undersized frames without padding
Message-ID: <20190530083508.i52z5u25f2o7yigu@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Operating-System: Linux 5.1.2 on a x86_64
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm trying to connect some VMs over EoGRE (using gretap on my side):

  ip link add foo type gretap remote <remote> local <local>

This works fine for large packets, but the system in the other end
drops smaller packets, such as ARP requests and small ICMP pings.

After looking at the GRE packets in Wireshark, it turns out the Ethernet
packets within the EoGRE packet is undersized (under 60 bytes), and Linux
doesn't pad them. I haven't found anything in RFC 7637 that says anything
about padding, so I would assume it should conform to the usual Ethernet
padding rules, ie., pad to at least ETH_ZLEN. However, nothing in Linux' IP
stack seems to actually do this, which means that when the packet is
decapsulated in the other end and put on the (potentially virtual) wire,
it gets dropped. The other system properly pads its small frames when sending
them.

Is there a way to get around this, short of looping the packets out through a
physical wire to get the padding? Is it simply a bug? I've been testing with
4.19.28, but it doesn't look like git master has any changes in this area.

/* Steinar */
-- 
Homepage: https://www.sesse.net/
