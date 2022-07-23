Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57F557F1FE
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 00:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbiGWWwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 18:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiGWWwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 18:52:31 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445CCB48F
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 15:52:29 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 26NMqEjw2154497;
        Sun, 24 Jul 2022 00:52:14 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 26NMqEjw2154497
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1658616735;
        bh=SuTIRD/pcIv5ZRhA+7EFnBXaV8bjuDHI31zEIEZ9C6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jqeVCDwO9sRVO7GuHyUpmYm/ZW7e77wcBU6YduJRXJCASxaenszIOj1BHxkDjsRS7
         rMmA4CA7useqGCqsjool7/sYDF09KrBxbNMF+qYMp1fPP/OBR8KsQBPB5ecvq45i9T
         KkceEeFKR3+asP0qyOCRS8G/jiTGyNOrvJO38qYk=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 26NMqD6w2154496;
        Sun, 24 Jul 2022 00:52:13 +0200
Date:   Sun, 24 Jul 2022 00:52:13 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Mason Loring Bliss <mason@blisses.org>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org, hkallweit1@gmail.com
Subject: Re: Issue with r8169 (using r8168 for now) driving 8111E
Message-ID: <Ytx7nc3FosXV6ptC@electric-eye.fr.zoreil.com>
References: <YtxI7HedPjWCvuVm@blisses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YtxI7HedPjWCvuVm@blisses.org>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(more than current r8169 maintainer Cced -> Heiner Kallweit)

Mason Loring Bliss <mason@blisses.org> :
> Hi all. I was happily running Debian Buster with Linux 4.19.194 driving a
> pair of 8111E NICs as included on this board:
> 
>     https://www.aaeon.com/en/p/mini-itx-emb-cv1
> 
> I upgraded to Debian Bullseye running 5.10.127 and started seeing this
> popping up regularly in dmesg, with the status varying:
> 
>     r8169 0000:03:00.0 eth1: Rx ERROR. status = 3529c123

This message was emitted as INFO in 4.19 whereas 5.10 considers it WARN.

You may check/enable the relevant message level with ethtool. I would
naïvely expect v4.19 to silently detect the error.

For your information, the content of the faulty descriptor word is
summarized below:

OWN  0
EOR  0
FS   1 (first segment)
LS   1 (last segment)

MAR  0 (multicast)
PAM  1 (physical address match)
BAR  0
RESV 1 (reserved)

RESV 1 (reserved)
RWT  0
RES  1 (receive error summay)
RUNT 0

CRC  1 (CRC error)
UDP  0
TCP  0
IP   1 (IP checksum failure)

UDPF 1 (udp checksum failure)
TCPF 1 (tcp checksum failure)

Frame length 0x123 -> 291

The driver should receive and process this kind of CRC errored packet since
79d0c1d26e1eac0dc5b201e66b65cc5e4e706743 ("r8169: Support RX-FCS flag.")
provided ethtool was not used to disable it (see -k/-K and rx-fcs/rx-all).
tcpdump may thus help to identify some pattern in the packet.

HTH.

-- 
Ueimor
