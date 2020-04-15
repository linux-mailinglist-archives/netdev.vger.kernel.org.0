Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E481AB06A
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 20:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406847AbgDOSNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 14:13:49 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:40564 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406366AbgDOSNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 14:13:47 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0B1D1200B8;
        Wed, 15 Apr 2020 18:13:46 +0000 (UTC)
Received: from us4-mdac16-61.at1.mdlocal (unknown [10.110.50.154])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 08EC5800A3;
        Wed, 15 Apr 2020 18:13:46 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.104])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 969DD10004F;
        Wed, 15 Apr 2020 18:13:45 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5E702B8006B;
        Wed, 15 Apr 2020 18:13:45 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 15 Apr
 2020 19:13:40 +0100
Subject: Re: Correct tc-vlan usage
To:     Vladimir Oltean <olteanv@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        netdev <netdev@vger.kernel.org>
References: <CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <c658ea46-7d67-3218-f565-9b9c1a6b4ee2@solarflare.com>
Date:   Wed, 15 Apr 2020 19:13:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CA+h21hoxwRdhq4y+w8Kwgm74d4cA0xLeiHTrmT-VpSaM7obhkg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25356.003
X-TM-AS-Result: No-1.667500-8.000000-10
X-TMASE-MatchedRID: cgbqQT5W8hfmLzc6AOD8DfHkpkyUphL9GUqOjzOC7IpIYGsjR+GjshUr
        LSPFYmRzWMDF0fU26oaFhnNm59A/TIAiks/+pdsZ/ccgt/EtX/14XLNBjM9D5KkNinB6fCXecVo
        lGMdkWBtFYLspN6LyDSf5Mx1fc0AjsEBAuoaUqK+MLcQCq3frlsTttHDRkM91myiLZetSf8kir3
        kOMJmHTMIs1+7Tk9qQC24oEZ6SpSmb4wHqRpnaDgacuQnoWXpVXXVvMiSZZ5wWXRr8PB1OYRHtC
        yQW7RITclqJxyE+sjAaRvtcGnVk1MFy5rVOifyuKO85tyHAi6HvTkJiACKxJI+AINsBjc/u1Ufw
        uic5JbL9LYDTmJ61B7ZYo/NVyiDh06xyD5hyOLw=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.667500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25356.003
X-MDID: 1586974426-WGVy0J3eIIz4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/04/2020 18:59, Vladimir Oltean wrote:
> My problem is that the VLAN tags are discarded by the network
> interface's RX filter:
>
> # ethtool -S eno2
>      SI VLAN nomatch u-cast discards: 1280
>
> and this is because nobody calls .ndo_vlan_rx_add_vid for these VLANs
> (only the 8021q driver does).
You could try creating the VLAN interfaces anyway; no traffic will hit
 them, because the tc rule popped the VLAN, but they'll call the ndo.
Idk if that'll actually work though... and it'd still be possible to
 TX through the VLAN devices, which you don't want.

-ed
