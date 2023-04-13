Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC386E16C0
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 23:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjDMVxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 17:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjDMVw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 17:52:59 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB14EAD12
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 14:52:42 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id o6-20020a05600c4fc600b003ef6e6754c5so7054085wmq.5
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 14:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681422761; x=1684014761;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eF71ij8pxWyZhYVt1orxuJd+aknCAn5lJ1csNPfxOvI=;
        b=Kat4g/Dni0UAMxribZdDQiZkyu8D7XOOKtAPUTPlF1CFC7TUlANbav3Rc9dWxTf4Vc
         JcapkchigwVxrLJEVj45I7qqReqF3Loz5v8HUaLlGmpfRxSrTwnb4Ye1WXjy9QG/GWMo
         hGxqZehR/yd2YTrjrKj7nkEqmm7PguVanqa+R1a84sxPfaSo+lyv9MVdog5lqPJACV/s
         lMtj/tXhlmrMQ5a8qam6+1wY+D5Fe+tm3gf3WJCuEzc9GOFoTU5E1EBF0lUWUz+ZF5Oe
         K2Uu5tAeL88uodfDSfWLKEaYYssQXXEDe8l+PPDRYi9wS/uNEWIOhV3HB8HkDPeaVgHh
         Pz7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681422761; x=1684014761;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eF71ij8pxWyZhYVt1orxuJd+aknCAn5lJ1csNPfxOvI=;
        b=VBjno0d5qhIwWCpX9qB/RUhEuQRXlNKmBF/YuBf2lqeutwXtM6+ssif/yDGLU20Mb0
         srcavzs7I7kG88rBfAZ0mtF1nrwdZTcSJGlOIHYzn1zje7IJsAFI75J5UCSQ8kMHKfBl
         FmPZCdWW7EhfZWe6t54R1VR8Vfjm0BsmbmQuXNJR9X6ruKg0v8kwKXBgt0maqBGzZyia
         OSvKgaHXUrosxhaRDhkMm1M59la7kegoZzOUGk7CfmwR2/uT/azrJ89yS+vC85a4M6Fd
         kF18OmrTCvKD5//Nr6uqM4+mwo9SkykoJxOYdzurHyg6Ya2sknWnaITPcrmGeNOtPtvz
         QtYg==
X-Gm-Message-State: AAQBX9cRY2pFC+NzqOIW49mhDkQMmxAehOt+1yi1Ndj+Y5nj72miQM+9
        de34vnMD9kOyVlfSECR5ohc=
X-Google-Smtp-Source: AKy350bwNbdi4qNTJTL7ogpGI9QHoobp0Wac4YBwKuEbrwR24gNwQdnKv1LpCDb/IG2gEUqNSyfC3A==
X-Received: by 2002:a7b:cbd3:0:b0:3f0:a785:f0f5 with SMTP id n19-20020a7bcbd3000000b003f0a785f0f5mr2979364wmi.16.1681422761108;
        Thu, 13 Apr 2023 14:52:41 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id h16-20020a05600c315000b003ef6708bc1esm6484718wmo.43.2023.04.13.14.52.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 14:52:40 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 6/7] net: ethtool: add a mutex protecting
 RSS contexts
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, edward.cree@amd.com,
        linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
 <9e2bcb887b5cf9cbb8c0c4ba126115fe01a01f3f.1681236654.git.ecree.xilinx@gmail.com>
 <ea711ae7-c730-4347-a148-0602c69c9828@lunn.ch>
 <69612358-2003-677a-80a2-5971dc026646@gmail.com>
 <61041c56-f7d2-49f8-9fc3-57852a96105a@lunn.ch>
 <3623a7f3-6f90-8570-5b9a-10ff56cc04e5@gmail.com>
 <20230412190650.70baee3e@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <485ebfeb-61d7-7636-80af-50b6a008b6dc@gmail.com>
Date:   Thu, 13 Apr 2023 22:52:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230412190650.70baee3e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/04/2023 03:06, Jakub Kicinski wrote:
> IMO the "MCPU has rebooted" case is a control path, taking rtnl seems
> like the right thing to do. Does that happen often enough or takes so
> long to recover that we need to be concerned about locking down rtnl?

Normally we *do* hold RTNL across the reset handling path, and all the
 callers I can find take it.  But the existence of a more complicated
 condition guarding the ASSERT_RTNL() in EFX_ASSERT_RESET_SERIALISED()
 implies that there is, or at least was, a call site that doesn't;
 that makes me nervous about assuming it.

> aRFS can't sleep IIUC so the mutex is does not seem like a great match.

sfc punts aRFS filter insertion into a workitem, because you can't do
 MCDI without sleeping.  And aRFS was just one example; there's lots
 of other sources of filters in the driver (PTP, sync_rx_mode (device
 UC/MC addresses), VLAN filtering (NETIF_F_HW_VLAN_CTAG_FILTER)...).
 Some of those filters can also have EFX_FILTER_FLAG_RX_RSS (though
 not custom contexts).

So while I *think* the filter insert code could carefully go
   if (spec->flags & EFX_FILTER_FLAG_RX_RSS && spec->rss_context)
       ASSERT_RTNL();
 it's kinda hairy.  And if this is a *normal* level of hair for
 drivers to have in this area, then the "but driver writers don't
 understand locking!" argument doesn't really favour one solution over
 the other.  After all, the driver will still have to hold *some* lock
 to access this stuff, whether it's rss_lock or RTNL.
(Idk, maybe sfc is just uniquely complex and messy.  It wouldn't be
 the first time.)

> IOW I had the same reaction as Andrew first time I saw this mutex :(

Well I seem to be outvoted, so I'll have another crack at getting it
 to work with just RTNL (that's what I went for originally, actually,
 but one of the ASSERT_RTNL()s failed in test and I couldn't figure
 out why at the time.  Possibly trying to argue the case has helped me
 to understand more of the details!).
