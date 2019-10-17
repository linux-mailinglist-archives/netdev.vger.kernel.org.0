Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFF1DABE4
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 14:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405983AbfJQMXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 08:23:54 -0400
Received: from omta014.useast.a.cloudfilter.net ([34.195.253.205]:54347 "EHLO
        omta014.useast.a.cloudfilter.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728554AbfJQMXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 08:23:54 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Oct 2019 08:23:54 EDT
Received: from cxr.smtp.a.cloudfilter.net ([10.0.17.147])
        by cmsmtp with ESMTP
        id KwQjizG1IA2IjL4hzikheo; Thu, 17 Oct 2019 12:16:47 +0000
Received: from thunder.sweets ([68.100.138.62])
        by cmsmtp with ESMTPSA
        id L4hxiPWyUM0IhL4hyiqgqT; Thu, 17 Oct 2019 12:16:47 +0000
Authentication-Results: cox.net; auth=pass (LOGIN) smtp.auth=aspam@cox.net
X-Authority-Analysis: v=2.3 cv=ScqJicZu c=1 sm=1 tr=0
 a=3mkzfl4ircflX6G+lDqBYw==:117 a=3mkzfl4ircflX6G+lDqBYw==:17
 a=8nJEP1OIZ-IA:10 a=XobE76Q3jBoA:10 a=71KQwpx1L-N3QojtS6QA:9 a=wPNLvfGTeEIA:10
Received: from [10.10.10.15] (thunder.sweets [10.10.10.15])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by thunder.sweets (Postfix) with ESMTP id 6E5DA10348;
        Thu, 17 Oct 2019 08:16:41 -0400 (EDT)
Message-ID: <5DA85BA6.5020305@cox.net>
Date:   Thu, 17 Oct 2019 08:16:38 -0400
From:   Joe Buehler <aspam@cox.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20120201)
MIME-Version: 1.0
To:     linville@tuxdriver.com, netdev@vger.kernel.org
Subject: ethtool SFF-8472 issue
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAD2NnzwoFqIjBon3VjeCezAc8UZyZw4JKZ7xUbw9Eqo1RfLgurd67z5JuEGVk5WIcmAqrsheB1IrL/NeOBRhegHm+WN9HeQzQvfy7blCb3wGW/M7BpD
 d3c7AJ9/9EynlFZFEF9jFuz95KrxthZe0T+e+0B5Za1p5PLcegNKNYPXPfuqmYWL1VB2gq0ukxabxla5IXwUru7a8YhTqGsPfG8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In sfpdiag.c the sff8472_calibration routine does not look correct for
optical RX power.

The code is currently calculating this:

power = a + b*x + c*x + d*x // x is the raw A/D reading

First problem is that there is another term (SFF_A2_CAL_RXPWR4 in
sfpdiag.c) in SFF-8472 that has been dropped.

The more serious issue is that this computation is not correct.  The
SFF-8472 document could be a little clearer -- which is probably what
caused this -- but I think what it intends is a least-squares polynomial
fit to convert from A/D reading to RX power.

So the formula should be:

power = a + b *x + c*x*x + d*x*x*x + e*x*x*x*x

Joe Buehler

