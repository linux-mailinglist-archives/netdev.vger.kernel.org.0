Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0BF34AC35B
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbiBGP3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443995AbiBGPQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 10:16:27 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AC3C0401C3;
        Mon,  7 Feb 2022 07:16:26 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso13806548pjm.4;
        Mon, 07 Feb 2022 07:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=IwbC5GgraFRaOZ81Tu6X93hQoXdowAbRSopeguTSmFc=;
        b=hcfUDDOsZCztYEGe/mxWefKZqn+JNcaDtKUP7OKrlvEJnXG/7fU9pe5O91Xaq0io7i
         SHMfSdapc6V5YglntuSaKkB65K6U887NXJpaEEVsMS8I5SVsFtLlvtqEHUUBLlTqumUW
         ateUkSUpe+3vKeooly3rikst3qVyhPmmO9xuS2zgJITEgj8UQe4HnMosRS/yuTXUxDfW
         k0V++MLGfNLq5iwSZoCGhiZT3hzK6zIhK0Zt9TvEoESL5MHLPd7HNk0Uw7G5rdyJhfu3
         D6HKNSLHW6E2PVfSfTfDDI3iBPtOA6od7g3YV/Rx0Y4UvU6il0JsMJEMMUol0xnF8N8K
         kxAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=IwbC5GgraFRaOZ81Tu6X93hQoXdowAbRSopeguTSmFc=;
        b=mpXm0VQ6ArrL1epiVLTAinMZOUrxzl3LUhKTEbsmSMahgyBNUoEe8id13NlIVNdD00
         VQKCCGZwsavqVJJ+DSJjr2/NJSkwrv/Jt5wioDqG0xvxIcFBN9angGIuG6YJCuIqkQ9f
         wDKbU73DsPlSvszdsUL9BnTgFmungjF0fSCo0ETKVN9bFJ5Y0bXDPRWpqZf3KkkDTCEi
         fH6N7hlroy4ucQMUWw/7euNzbvabu6+l1NXNfKobfdfLEkG4Ql653ibPzSyQubFmJa6b
         qVeF6966VdsXA8R2GGWHms+OfyxovZIRakbNrHwEy4BVnZFAEtrOfs0dxpESmaQ7PJ5a
         esEQ==
X-Gm-Message-State: AOAM530qHHwq68vrAqrUMB13iZC8FOFSny+WDZ5cVOYmxfFczkTLDjo1
        vYBZpjKl0cRTFevoWZElPgo=
X-Google-Smtp-Source: ABdhPJwffx0JxoNKiyAoQ9V5iWqcodJHDZCEkvSKQ0Y9jRGhuG44O8WmHV0bIcteHCGoN789PL6lEw==
X-Received: by 2002:a17:902:a5c1:: with SMTP id t1mr16582992plq.106.1644246986367;
        Mon, 07 Feb 2022 07:16:26 -0800 (PST)
Received: from [10.59.0.6] ([85.203.23.80])
        by smtp.gmail.com with ESMTPSA id m21sm12823728pfk.26.2022.02.07.07.16.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 07:16:25 -0800 (PST)
Message-ID: <4a850d04-ed6a-5802-7038-a94ad0d466c5@gmail.com>
Date:   Mon, 7 Feb 2022 23:16:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Content-Language: en-US
To:     tariqt@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] net: mellanox: mlx4: possible deadlock in mlx4_xdp_set() and
 mlx4_en_reset_config()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

My static analysis tool reports a possible deadlock in the mlx4 driver 
in Linux 5.16:

mlx4_xdp_set()
   mutex_lock(&mdev->state_lock); --> Line 2778 (Lock A)
   mlx4_en_try_alloc_resources()
     mlx4_en_alloc_resources()
       mlx4_en_destroy_tx_ring()
         mlx4_qp_free()
           wait_for_completion(&qp->free); --> Line 528 (Wait X)

mlx4_en_reset_config()
   mutex_lock(&mdev->state_lock); --> Line 3522 (Lock A)
   mlx4_en_try_alloc_resources()
     mlx4_en_alloc_resources()
       mlx4_en_destroy_tx_ring()
         mlx4_qp_free()
           complete(&qp->free); --> Line 527 (Wake X)

When mlx4_xdp_set() is executed, "Wait X" is performed by holding "Lock 
A". If mlx4_en_reset_config() is executed at this time, "Wake X" cannot 
be performed to wake up "Wait X" in mlx4_xdp_set(), because "Lock A" has 
been already hold by mlx4_xdp_set(), causing a possible deadlock.

I am not quite sure whether this possible problem is real and how to fix 
it if it is real.
Any feedback would be appreciated, thanks :)


Best wishes,
Jia-Ju Bai
