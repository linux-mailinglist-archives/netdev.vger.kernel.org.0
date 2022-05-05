Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D7B51C1E7
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240825AbiEEOKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiEEOKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:10:45 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCF344A19
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 07:07:06 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d17so4528760plg.0
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 07:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=znH8nH+BpyNQPkFlEqim2EXvsvzx7dA6qs0fYk6BSOg=;
        b=QXvO4X47sG+fK+nJIhP/AvYuyVW0ssMMaWuhcyDcNKiAMLPkQbOk+4XMm64PTHwpv3
         qSeLmT30xEnwq73gPYb4gBfV4oUO/8WH67DYs4RzUmUoUOBZQkhaX8QEP3kc1d3T6OSi
         LtONeb3G8tF92y0cU+Wlbo4HBav+4dqRI3kJkZdpdpO5yFPSPu+Ngq0nvG3VeKupCdB9
         kwLku1O3//WKT+IRPTXolPaoHkVPff/loGmKqnJPOQ4yku4QfNfc4ij6tt2yNG+pJB+/
         X2gOha72pBd7L+lu8WcquYFD65fd16+Ik35uSOHlsvZ0LySGKNHfmI9TgQOMC64WYkqQ
         Rx2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=znH8nH+BpyNQPkFlEqim2EXvsvzx7dA6qs0fYk6BSOg=;
        b=tUgqXBe8ia1WVgvE4/Pf//1I9vNq7CUhtLbmyMMEaDIma1p4p0q6nNdEVZEvCNa1u3
         TZTOVNq7LAvS5VtlsEzvokxfdzyz2nAdxec2aDXt8m4aXFANhCpKittLE7Bp+/+Oj90D
         I8T4a9+5qFElA9CB3lZisd06oZkgocQ437Qavrf/JlWuVIDCtIi9uyQqofOkBQOTuzXN
         yvTiLXIMN1TzkQK1FZQPB2GKwc6zqKfglJACbkwZ046zuAAcUWSiV/uEdCAN/+su5WDH
         Fibme1OuN5VR/UAym4lJceeADquFJbiVaSkk/zQd5Npzj3+DtH+hhkJvlzDdGsHVOee3
         hS9g==
X-Gm-Message-State: AOAM5338gfn+zkFOOcTcNPmQw1BXcNxwqd85kOoRhxbdTg6YWFrdbW+R
        XN1QK/qBNISlu1oyMRqG3wI=
X-Google-Smtp-Source: ABdhPJzqbGbwehcfpMfZAFg3MLU/552EK8iGZcSffxqIp32zX7Dn9CBqPkOVX4lg+hSoe7KhYtpYgw==
X-Received: by 2002:a17:902:e546:b0:15e:b129:7d8 with SMTP id n6-20020a170902e54600b0015eb12907d8mr16938160plf.138.1651759625577;
        Thu, 05 May 2022 07:07:05 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id ot16-20020a17090b3b5000b001dc4d22c0a7sm1618235pjb.10.2022.05.05.07.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 07:07:04 -0700 (PDT)
Date:   Thu, 5 May 2022 07:07:02 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     vinicius.gomes@intel.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org, mlichvar@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 5/6] ptp: Speed up vclock lookup
Message-ID: <20220505140702.GD1492@hoboy.vegasvil.org>
References: <20220501111836.10910-1-gerhard@engleder-embedded.com>
 <20220501111836.10910-6-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501111836.10910-6-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 01, 2022 at 01:18:35PM +0200, Gerhard Engleder wrote:
> ptp_convert_timestamp() is called in the RX path of network messages.
> The current implementation takes ~5000ns on 1.2GHz A53. This is too much
> for the hot path of packet processing.
> 
> Introduce hash table for fast vclock lookup in ptp_convert_timestamp().
> The execution time of ptp_convert_timestamp() is reduced to ~700ns on
> 1.2GHz A53.

50 times faster... nice improvement!
 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
