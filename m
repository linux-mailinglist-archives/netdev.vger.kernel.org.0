Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B589F4F6D4A
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbiDFVt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbiDFVtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:49:45 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571432ADF
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 14:36:16 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id s2so3673482pfh.6
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 14:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3ZqGnquzrw04i9RM2COM2RYdBRQyPsyMdisp2duIj8Y=;
        b=aTd8kBi0dESCOo0ACqfnbicT2dPVP4fVDQvg4o6aqhInQeSoaoH6qyccBzomOXuk+h
         Hz+vDmvOc2u5sSQGznDpRyuWm81qE4xnETmZz7rZz4pqnWGllPLIPxz7gwvJ3kDlhpeG
         VB42fpWVS7ijI9KBdpJdeVPa/yRnZ4vft/Y8A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3ZqGnquzrw04i9RM2COM2RYdBRQyPsyMdisp2duIj8Y=;
        b=Ezvt4th3Bf9Kdbxor5RQYkA5UGDjlRHJF8KYgsSHu7M0WHiq9wfbsna1qeOUoqplfS
         78gZc82QfuoZgypBxqpNzBYTQRnaSXoMkxoUydIDDjoUV0gRbUz4LNTEDKxjl579ikTY
         yliu3mnX4kDO6sZ3KTHguXQOL8UgKmn6oLOUtndkdJMx4HGTUes+v8tK1kTJ9IrYCe72
         BPhBnBnM7J5OMnGrXHjPhfTO/dSmVase2Ji8hOEnxMxuuHRyKDQ/a/M7Hgdl/lwPCuq8
         HYNDAVkZiFB9wgaPURfoMMqZ6AH0RYB1ETEzO9bnOtEmgghymL32pUVLbrZOCrDvbX8Z
         S3Kw==
X-Gm-Message-State: AOAM531xTPujlLdS5F1U5nKod0KR8P4era5w3Uc0j0vM7ZHBvM35zfd7
        WdbyhCHT8+w6TnvSHxqP5SeNMA==
X-Google-Smtp-Source: ABdhPJyXzczJ0K32H6XLjb0hYPpDHL2FVuvPBChgCPiu2MrZWrvSoqTX0ZXtXa1jsgN8MK+5ZLRJ4g==
X-Received: by 2002:a63:214e:0:b0:399:1123:a388 with SMTP id s14-20020a63214e000000b003991123a388mr8806356pgm.66.1649280975873;
        Wed, 06 Apr 2022 14:36:15 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f16-20020a056a001ad000b004fb358ffe86sm20258774pfv.137.2022.04.06.14.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 14:36:15 -0700 (PDT)
Date:   Wed, 6 Apr 2022 14:36:14 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        gustavoars@kernel.org, kurt@linutronix.de
Subject: Re: [PATCH net] flow_dissector: fix false-positive
 __read_overflow2_field() warning
Message-ID: <202204061435.69D056F@keescook>
References: <20220406211521.723357-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406211521.723357-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 02:15:21PM -0700, Jakub Kicinski wrote:
> Bounds checking is unhappy that we try to copy both Ethernet
> addresses but pass pointer to the first one. Luckily destination
> address is the first field so pass the pointer to the entire header,
> whatever.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Ah yes, thanks! I had prepared this patch last week, but failed to
actually send it. :|

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
