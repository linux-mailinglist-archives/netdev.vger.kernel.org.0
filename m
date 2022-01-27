Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B02949D87D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiA0Cvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:51:53 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:41090
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229484AbiA0Cvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 21:51:53 -0500
Received: from [192.168.1.9] (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id EC3E03F129;
        Thu, 27 Jan 2022 02:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643251911;
        bh=LBUehqk8gQpUGcdbarOarHEa02BgvqMCfwJk3piGG0A=;
        h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
         In-Reply-To:Content-Type;
        b=iJkLGf4/IaaV6AdTc7epeqN3+ZVmADHYh/N2CnsTin84SdwB/H4kQPy7z2xGWxVf2
         7pyhyDAJqS0WGP5zlG0VAiU5eP1Z+s2vSuFzH1kTBSzAbzCRbNj7TYXCKfA6S5nOYv
         v7ifhGzId8blIMhIr4vJdXJ/gSbSODe+jQWRLa1s1RJcj+/KVOesnMzYUfQLqyR2KN
         PgVu1GLIrzXra8GCDu3iQZAo++WFtYakA3CN5C7VDOhbb34EELqpJN1kap2gOfvzFd
         gZ6Xgk8j3JKoYZo3Ra3h9EgLCsck1rD9gT4X/bTwcIrfYZZzVzb1PtKqyuj+TXtkTy
         6f9sDd5r33S4w==
Message-ID: <edff6219-b1f7-dec5-22ea-0bde9a3e0efb@canonical.com>
Date:   Thu, 27 Jan 2022 10:51:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Content-Language: en-US
From:   Aaron Ma <aaron.ma@canonical.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Henning Schild <henning.schild@siemens.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hayeswang@realtek.com" <hayeswang@realtek.com>,
        "tiwai@suse.de" <tiwai@suse.de>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <CAAd53p5YnQZ0fDiwwo-q3bNMVFTJSMLcdkUuH-7=OSaRrW954Q@mail.gmail.com>
 <20220106183145.54b057c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
 <20220110085110.3902b6d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAAd53p5mSq_bZdsZ=-RweiVLgAYU5+=Uje7TmYtAbBzZ7XCPUA@mail.gmail.com>
 <ec2aaeb0-995e-0259-7eca-892d0c878e19@amd.com>
 <20220111082653.02050070@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
 <20220111084348.7e897af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <2b779fef-459f-79bb-4005-db4fd3fd057f@amd.com>
 <20220111090648.511e95e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5411b3a0-7e36-fa75-5c5c-eb2fda9273b1@amd.com>
 <20220112202125.105d4c58@md1za8fc.ad001.siemens.net>
 <DM4PR12MB516889A458A16D89D4562CA7E2529@DM4PR12MB5168.namprd12.prod.outlook.com>
 <de684c19-7a84-ac7c-0019-31c253d89a5f@canonical.com>
In-Reply-To: <de684c19-7a84-ac7c-0019-31c253d89a5f@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Realtek 8153BL can be identified by the following code from Realtek Outbox driver:
} else if (tp->version == RTL_VER_09 && (ocp_data & BL_MASK)) {

I will suggest Realtek to send out this change for review.

Thanks,
Aaron

On 1/13/22 11:23, Aaron Ma wrote:
> Before made that patch I already discussed with Lenovo.
> And didn't get any other opinion. The solution is from a discussion with them.
> 
> This info had been forward to them too.
