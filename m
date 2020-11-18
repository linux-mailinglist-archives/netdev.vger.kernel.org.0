Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0282B7407
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgKRB6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:58:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgKRB6B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 20:58:01 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3FC624248;
        Wed, 18 Nov 2020 01:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605664680;
        bh=BKzShis1OrXHR5GsisHpZh2qQSEw8GQT9vWsUy2NbI4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wT03+bGqqA9g15QX73+13Z8xIewwEL80h2+J9HwZmJJ31Oz1MfQcLPWDba0TO3t7P
         dI0sTxJtgqihmTEO2O3e2RDiON2jkUJE50Uepf9FcXhheKL0d3ol4kwFL45KtN04xf
         xAyZuItLb/Lpiqbn32jNUxQAt89hlL/JBUJA+Grg=
Date:   Tue, 17 Nov 2020 17:57:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net/nfc/nci: Support NCI 2.x initial sequence
Message-ID: <20201117175758.3befce93@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117053759epcms2p80e47c3e9be01d564c775c045a42678f7@epcms2p8>
References: <CGME20201117053759epcms2p80e47c3e9be01d564c775c045a42678f7@epcms2p8>
        <20201117053759epcms2p80e47c3e9be01d564c775c045a42678f7@epcms2p8>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 14:37:59 +0900 Bongsu Jeon wrote:
> implement the NCI 2.x initial sequence to support NCI 2.x NFCC.
> Since NCI 2.0, CORE_RESET and CORE_INIT sequence have been changed.
> If NFCEE supports NCI 2.x, then NCI 2.x initial sequence will work.
> 
> In NCI 1.0, Initial sequence and payloads are as below:
> (DH)                     (NFCC)
>  |  -- CORE_RESET_CMD --> |
>  |  <-- CORE_RESET_RSP -- |
>  |  -- CORE_INIT_CMD -->  |
>  |  <-- CORE_INIT_RSP --  |
>  CORE_RESET_RSP payloads are Status, NCI version, Configuration Status.
>  CORE_INIT_CMD payloads are empty.
>  CORE_INIT_RSP payloads are Status, NFCC Features,
>     Number of Supported RF Interfaces, Supported RF Interface,
>     Max Logical Connections, Max Routing table Size,
>     Max Control Packet Payload Size, Max Size for Large Parameters,
>     Manufacturer ID, Manufacturer Specific Information.
> 
> In NCI 2.0, Initial Sequence and Parameters are as below:
> (DH)                     (NFCC)
>  |  -- CORE_RESET_CMD --> |
>  |  <-- CORE_RESET_RSP -- |
>  |  <-- CORE_RESET_NTF -- |
>  |  -- CORE_INIT_CMD -->  |
>  |  <-- CORE_INIT_RSP --  |
>  CORE_RESET_RSP payloads are Status.
>  CORE_RESET_NTF payloads are Reset Trigger,
>     Configuration Status, NCI Version, Manufacturer ID,
>     Manufacturer Specific Information Length,
>     Manufacturer Specific Information.
>  CORE_INIT_CMD payloads are Feature1, Feature2.
>  CORE_INIT_RSP payloads are Status, NFCC Features,
>     Max Logical Connections, Max Routing Table Size,
>     Max Control Packet Payload Size,
>     Max Data Packet Payload Size of the Static HCI Connection,
>     Number of Credits of the Static HCI Connection,
>     Max NFC-V RF Frame Size, Number of Supported RF Interfaces,
>     Supported RF Interfaces.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>

Please fix the following sparse (build with C=1) warning:

net/nfc/nci/ntf.c:42:17: warning: cast to restricted __le32

> +	__u8 status = 0;

Please don't use the __u types in the normal kernel code, those are
types for user space ABI.
