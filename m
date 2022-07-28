Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E31583FBC
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 15:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbiG1NPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 09:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239180AbiG1NPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 09:15:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC1311FCE9
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 06:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659014133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HUKi8MrGrEGip8RjX9SW44lSQ53nVGkUaTRQzQgM+mc=;
        b=HYQuCF3Xtdm6UtTY0875cE0+pguSEgY0EwMWzwxanOEs89MyL2xMydg2UJwDONBCtOAmTM
        oIwQJ8MYbqdgxP4iP+xa5lnJfFZTSvTcFLHlGmesGVjKKK5cyFkJZWgUZdaeQOPQUaB18A
        ypQpAB5wkw0pIiFvHFKGEcEsxBDGFjs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-3lQeTtKBOZCg0MON5qSUzw-1; Thu, 28 Jul 2022 09:15:29 -0400
X-MC-Unique: 3lQeTtKBOZCg0MON5qSUzw-1
Received: by mail-qk1-f198.google.com with SMTP id ay35-20020a05620a17a300b006b5d9646d31so1428150qkb.6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 06:15:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=HUKi8MrGrEGip8RjX9SW44lSQ53nVGkUaTRQzQgM+mc=;
        b=oYe1Ve8HFVkZVOuXfVfAYfdfGoMVqE15e7uF1hStomtqN6x+wn2rdvYkNN+6r/F773
         dzyFrniuGKGgIWztkTJPoYsgH/jUQrc32/K7UInf8X6+UVD79pUl5MZy5p8mY9ar4ElL
         Kfg30sweD7s9OVDl1b/2mgdtDmfjdX12l+L5rvtKvTTUJzcw2KtOCig3xkJVJmepdLtH
         8vcxNATyJbTG93J0r8TalvZySXVAk3cnC6B+sXVDjsbX5/DV+Z73Tk7Rmyo0oYF+EX2V
         KnER1QOP5lm3ON3S17aDthc1rDhdqWvMz2fy5K35078bkz7lK0+9S5Auhl0l7Q/oiHDU
         DK2g==
X-Gm-Message-State: AJIora/Q1k/EIEDMAAq1g3HteJ0pLwgYWBgpSqkgQrxNE0q1JoLjhX/Y
        FdQWvsLGrGrfGhHliT/zu8sVrk/Pc8vy8gwI7e8sJBFv217+mYTDAcTl3AcYUVx2K6IZuTz4xkV
        puVkaZjnHQUCH0uR2
X-Received: by 2002:a05:6214:cc8:b0:474:6de0:f8a5 with SMTP id 8-20020a0562140cc800b004746de0f8a5mr10225700qvx.105.1659014128589;
        Thu, 28 Jul 2022 06:15:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vnztfGuboYDJJTLbZyvBfyH4pWFGcQG4mFGGhLbhGjmrdN/43PJLdxBRtlxurmakQ1oR06+w==
X-Received: by 2002:a05:6214:cc8:b0:474:6de0:f8a5 with SMTP id 8-20020a0562140cc800b004746de0f8a5mr10225677qvx.105.1659014128310;
        Thu, 28 Jul 2022 06:15:28 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id bt8-20020ac86908000000b0031f16e7f899sm437997qtb.45.2022.07.28.06.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 06:15:27 -0700 (PDT)
Message-ID: <8275d40f7154c3a4e4acc4d3779af38abb061df5.camel@redhat.com>
Subject: Re: [PATCH] net: dsa: microchip: remove of_match_ptr() from
 ksz9477_dt_ids
From:   Paolo Abeni <pabeni@redhat.com>
To:     Souptick Joarder <jrdr.linux@gmail.com>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Date:   Thu, 28 Jul 2022 15:15:23 +0200
In-Reply-To: <20220727025255.61232-1-jrdr.linux@gmail.com>
References: <20220727025255.61232-1-jrdr.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-07-27 at 08:22 +0530, Souptick Joarder wrote:
> From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
> 
> > > drivers/net/dsa/microchip/ksz9477_i2c.c:89:34:
> warning: 'ksz9477_dt_ids' defined but not used [-Wunused-const-variable=]
>       89 | static const struct of_device_id ksz9477_dt_ids[] = {
>          |                                  ^~~~~~~~~~~~~~
> 
> Removed of_match_ptr() from ksz9477_dt_ids.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>

As this looks like a fix, could you please post a new revision of the
patch including into the commit message a proper 'Fixes' tag?

Thanks!

Paolo

