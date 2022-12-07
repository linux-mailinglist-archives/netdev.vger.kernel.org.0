Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31288645A68
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiLGNHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiLGNGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:06:54 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0B256EEA;
        Wed,  7 Dec 2022 05:06:43 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id m18so12286183eji.5;
        Wed, 07 Dec 2022 05:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1n2xKrEJmiAiMH62NDMHkE+KBXQtCMKJa3DDPhNfqEs=;
        b=AAh8sB6+TGuCresy/bUkOIqesyfwoCEYUjfvpNrkqane3PYjXJ0INpQtaz4OpPenfK
         ExqNue+tHfXrjp6+lwS98JYigX5lU0SDhxhIWr/ibeKz1OIfV230t2H64Whl3G+5DKFC
         z0g0vC0Vm0e8LAETOuPet5yjA+gNCcmjzRCferk7c71mAC1K18vm4Wr1cICwCB13fhgT
         Xll+srZQaiqGbXIJ8KR1GuwnSu5c33SfQt+PxO62ckdqJgqqshBCV4z1F9fTLZLy1mK6
         BdPv7IEo2YoFcfzX6OBHjzy+uoSUJIcjRoIf6pT1ijKrbQ5kc6w62EElDu/OPa0vHhmM
         ag0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1n2xKrEJmiAiMH62NDMHkE+KBXQtCMKJa3DDPhNfqEs=;
        b=HnoQEKXtLbM/I+A+mbgYTvNw91l/4i+bZ84v9yAVedN/hGUPqY1sdMORrkehuMF6DP
         8QaR7erHS2a0eOUGjkVq6fZsNFQVpc6+Im8IIxZwbN/ZdXGbnPt7dfrd30Z2rhSDvFFx
         cL9iGULFac8UiQlgqQoeNDeO5D76F7wFBT5zp1+pJrHv6ESDe9jJnHMBIkmI4SJ3aV+l
         GFb9wlYt0RlTlztbjtFrTCSmUGN7RqVjMEBzDGK3aJzcA7TnNPFybjoQpmOlaIROPiQk
         scZXsqMO7CIra5Q01hWuQSC6zhTBBqinJgsgUK1Ae/GGdV2zd+qBsTg5sfZXuHDyRcZP
         Fpxg==
X-Gm-Message-State: ANoB5pnoxa2OrGdGhEdJuOTXAVek894QWhIDc0eUqaniF5evvyDN3/Ha
        CqAeUt0zPvEiXRFMDhVzvBgyBcfnRAd7uA==
X-Google-Smtp-Source: AA0mqf6VhiuMb59vUW55mSPfqpifujJ43V5lPqoqws22HvOkjYbrkl3dHJPhd+FQrZnofDv+FCs4dg==
X-Received: by 2002:a17:906:b45:b0:7c1:f69:71bb with SMTP id v5-20020a1709060b4500b007c10f6971bbmr5192215ejg.685.1670418402037;
        Wed, 07 Dec 2022 05:06:42 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id u25-20020aa7db99000000b0046c7c3755a7sm2185173edt.17.2022.12.07.05.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:06:41 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:06:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] lib: packing: fix shift wrapping in bit_reverse()
Message-ID: <20221207130639.ta3zodrx4el766g5@skbuf>
References: <Y5B3sAcS6qKSt+lS@kili>
 <Y5B3sAcS6qKSt+lS@kili>
 <20221207121936.bajyi5igz2kum4v3@skbuf>
 <Y5CFMIGsZmB1TRni@kadam>
 <20221207122254.otq7biekqz2nzhgl@skbuf>
 <Y5CMPGrSuP+0ptdP@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5CMPGrSuP+0ptdP@kadam>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 03:51:08PM +0300, Dan Carpenter wrote:
> My crappy benchmark says that the if statement is faster.  22 vs 26
> seconds.

Sure that's not just noise in the measurements? :)
