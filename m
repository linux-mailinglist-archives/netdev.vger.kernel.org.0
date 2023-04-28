Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCA66F1073
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 04:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjD1CgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 22:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjD1CgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 22:36:13 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36E3268D
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 19:36:12 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-63b4e5fdb1eso10685132b3a.1
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 19:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1682649372; x=1685241372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5mabVRxzEGGHbF8RBp4qV18M2pQVzukOEEXZ/JbaAVw=;
        b=yR2ujzKAjK0kwnfoHkSiD0Q/a3rqL3ZmFI757Hj5nUlTZZVaCTXh+VLoqXKomGSZfi
         4ZtHvKRXxNVqCEX2gpjJlwSou8cMUPvJ4Tu+QVDLigLlajRD9WNTdpYh7A18toRqfHP3
         s4REkHFTFs+17a/nPcE34QCa6SSs/HC+DeVoiaGOFtjqPq6TUrm+1MIZHooroRT8lHBJ
         /raTKgyAaWF2hRF8DzMEzAkqC316C7+a4uDzBfUYgnepppp6wrX56XyA8kJjJEXsUIcb
         v1e2Jc/4rONpJXbTcLpNi/hm/u3zWIYO8bXkFhs72n9sRp9dpjbiho4Ddo1zeBhdGegY
         SgdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682649372; x=1685241372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5mabVRxzEGGHbF8RBp4qV18M2pQVzukOEEXZ/JbaAVw=;
        b=IW24HijHoGBPE3FmX4iZkt0qDEIy9PLx+B4LvoHsDwed4qxRHYE2BdK7jlMEmy8rfG
         5mYF1qXjTO7hpuNX5Jt0zUOxxW0bYKhx3IN7996ZlAmC2hbNemDBL+suvdAENGfNgnz7
         KCpbEx6bg6KgqpAAOAH37e0ekWNNWwrpTJIzfks/rB3VDecZRBxMU0DQtBcsNa56gYMP
         +9oHaQ4dVKIAAaAiwDuhW2+jc8CQaf78KEcX8p6BRPPi3tPmTffDAOPp6XBa6Y25fJ4o
         vdBBGy1Lqgi2vwH3X3b4FyizvGAFXFomm5+GY6rRTwsQwP6UxV01MAH46+bCyrGaOuwW
         OL4w==
X-Gm-Message-State: AC+VfDwJA0qAOiJ4k1ikhH+H/6R67TpCrGIt7vn25vMLtODGpQAvSYRD
        QvzcTNfHdMaV/NMwuv8HHZXU/Q==
X-Google-Smtp-Source: ACHHUZ4yFH/hBsrNG9tlS5VkUNVltVqd0Sr2iuScvyjUmezEA6kgB9cLlVBoRlIFWUWRFNGsJxwH6A==
X-Received: by 2002:a05:6a21:9205:b0:f1:2096:405a with SMTP id tl5-20020a056a21920500b000f12096405amr3736364pzb.28.1682649372411;
        Thu, 27 Apr 2023 19:36:12 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id u10-20020a63234a000000b0050be8e0b94csm11755469pgm.90.2023.04.27.19.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 19:36:12 -0700 (PDT)
Date:   Thu, 27 Apr 2023 19:36:10 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Jiri Pirko <jiri@nvidia.com>, <poros@redhat.com>,
        <mschmidt@redhat.com>, <netdev@vger.kernel.org>,
        <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v7 7/8] netdev: expose DPLL pin handle for netdevice
Message-ID: <20230427193610.6d620434@hermes.local>
In-Reply-To: <20230428002009.2948020-8-vadfed@meta.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
        <20230428002009.2948020-8-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Apr 2023 17:20:08 -0700
Vadim Fedorenko <vadfed@meta.com> wrote:

> +size_t dpll_msg_pin_handle_size(struct dpll_pin *pin)
> +{
> +	// TMP- THE HANDLE IS GOING TO CHANGE TO DRIVERNAME/CLOCKID/PIN_INDEX
> +	// LEAVING ORIG HANDLE NOW AS PUT IN THE LAST RFC VERSION

Please don't use C++ style comments
