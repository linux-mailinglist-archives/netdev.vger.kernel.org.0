Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0481290D17
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 23:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410572AbgJPVFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:05:08 -0400
Received: from server139.web-hosting.com ([104.219.248.44]:38404 "EHLO
        server139.web-hosting.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392781AbgJPVFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 17:05:08 -0400
X-Greylist: delayed 2254 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Oct 2020 17:05:07 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=gentil.com;
         s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sHMhCA8rDLuNM2TBbdntuJxD4Wlzrmz2hMZn6SssMTg=; b=dLHqQbiMCYM7wkZuy1Y7dEDl+M
        /ZH019BWWyWvPomGWjwUN/guoaXMQNQ45BiI8OVXVuIGOu2dXYNF5jiH0q4YAEDv3lqzcV4Q5GRng
        53+yzHRHCEqyxkMEGbz6+bWOcMq7uwBuIXroWXPba/YL4HHtCtnpcNGlmc566xFUpLPPGJ1BUjuCh
        14AE7KlBMdGyuUTwaQAAFT/fTmc5jGnN5JpAJEyCrtKSEGabWubRMbP26H3DaWoe7qHLlIPt92ums
        t9VhI6F4gENmTu8VZVpcPTd1Z5uaIZS2D1mu7RGilIn0MChEICkKdUIXSQ0vy4dSDRWiRN1GihLtP
        r/RyHqew==;
Received: from [98.207.153.78] (port=48154 helo=[192.168.10.25])
        by server139.web-hosting.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gregoire@gentil.com>)
        id 1kTWK1-001PeX-DN
        for netdev@vger.kernel.org; Fri, 16 Oct 2020 16:27:33 -0400
To:     netdev@vger.kernel.org
From:   Gregoire Gentil <gregoire@gentil.com>
Subject: How to disable CRC32 FCS in stmmac (v3.5)?
Organization: Gregoire Gentil
Message-ID: <1007a52d-8399-1952-3c1b-0b37e7e02437@gentil.com>
Date:   Fri, 16 Oct 2020 13:27:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-OutGoing-Spam-Status: No, score=-0.2
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server139.web-hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gentil.com
X-Get-Message-Sender-Via: server139.web-hosting.com: authenticated_id: gregoire@gentil.com
X-Authenticated-Sender: server139.web-hosting.com: gregoire@gentil.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-From-Rewrite: unmodified, already matched
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a FPGA sending frames (payload length=1280) over RGMII to a 
Samsung module which includes STMMAC MAC IP (v3.5).

If the FCS is correct, I manage to receive data from the FPGA to the MAC 
in the kernel.

For multiple reasons, I wish to disable FCS so that frames are received 
in the kernel even if the 4-byte CRC FCS are wrong.

After a lot tries for the past few weeks, I don't manage to receive 
error frames. Especially, if FCS is wrong, I don't get anything in 
"stmmac_rx(struct stmmac_priv *priv, int limit)".

Here is a list of all the relevant bits I have played with:

C006_0000h (CST 25): CRC Stripping for Type Frames
C006_0000h (IPC 10): Checksum Offload
C006_0000h (ACS 7): Automatic Pad or CRC Stripping
C006_1018h (DT 26): Disable dropping of TCP/IP Checksum Error Frames
C006_1018h (FEF 7): Forward Error Frames

Whithout any special hacking, my default registers are:
C006_0000h: 0x1100880 (25:0, 10:0, 7:1)
C006_1018h: 0x2202006 (26:0, 7:0)

I have also unsuccessfully played with "ethtool --offload eth0 rx off"

The MAC registers documentation is rather sparse and written in flaky 
English though it seems that the register description table is a copy 
paste from the original ST documentation.


Has anyone managed to achieve my objective, getting rid of FCS frame drop?

Grégoire
