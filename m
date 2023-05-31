Return-Path: <netdev+bounces-6743-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50175717BAA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:20:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E05AF1C20E26
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2466AD30A;
	Wed, 31 May 2023 09:20:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135AEBE70
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:20:53 +0000 (UTC)
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD625C0
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 02:20:50 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
	id 4D35A5874F400; Wed, 31 May 2023 11:20:44 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 4B79660C0132C;
	Wed, 31 May 2023 11:20:44 +0200 (CEST)
Date: Wed, 31 May 2023 11:20:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Sam Edwards <cfsworks@gmail.com>
cc: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
    "David S. Miller" <davem@davemloft.net>
Subject: Regression in IPv6 autoconf, maybe "ipv6/addrconf: fix timing bug
 in tempaddr regen"
Message-ID: <4n64q633-94rr-401n-s779-pqp2q0599438@vanv.qr>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Greetings.

I am observing that between kernel 5.19 and 6.0, a change was introduced 
that makes the system just stop generating IPv6 Privacy Addresses after 
some time. With regeneration parameters in sysctl (see below) reduced to 
almost the minimum supported by Linux (that would be 900s), the 
timeframe to reproduction is somewhat elongated but managable (7 hours), 
so I have not completely bisected it down yet. Based on the shortlog for 
inbetween those two kernel versions, a glance at the shortlog leads me 
to a hypothesis that this commit could be the culprit:

commit 778964f2fdf05e5d2e6ca9bc3f450b3db454ba9c
Author: Sam Edwards <cfsworks@gmail.com>
Date:   Thu Jun 23 12:11:04 2022 -0600

    ipv6/addrconf: fix timing bug in tempaddr regen
    
    The addrconf_verify_rtnl() function uses a big if/elseif/elseif/... block
    to categorize each address by what type of attention it needs.  An
    about-to-expire (RFC 4941) temporary address is one such category, but the
    previous elseif branch catches addresses that have already run out their
    prefered_lft.  This means that if addrconf_verify_rtnl() fails to run in
    the necessary time window (i.e. REGEN_ADVANCE time units before the end of
    the prefered_lft), the temporary address will never be regenerated, and no
    temporary addresses will be available until each one's valid_lft runs out
    and manage_tempaddrs() begins anew.
    [...]

sysctl config:
net.ipv4.conf.default.forwarding=1
net.ipv6.conf.default.use_tempaddr=2
net.ipv6.conf.default.router_solicitation_interval=60
net.ipv6.conf.default.max_addresses=1500
net.ipv4.conf.all.forwarding=1
net.ipv6.conf.all.use_tempaddr=2
net.ipv6.conf.all.router_solicitation_interval=60
net.ipv6.conf.all.max_addresses=1600
net.ipv6.conf.all.temp_prefered_lft=1500
net.ipv6.conf.ge0.max_addresses=1600
net.ipv6.conf.ge0.temp_prefered_lft=1500

