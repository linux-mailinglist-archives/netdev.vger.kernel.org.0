Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923324B2DE2
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 20:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352906AbiBKTkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 14:40:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235494AbiBKTkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 14:40:36 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0FBCF6
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 11:40:35 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso9762833pjh.5
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 11:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GmXwDuGaXPIAjcN3yXogn03ChpqhhOxCUz2e/GVNFfo=;
        b=z7w0Eh7R0z249wa1x1VPOVkhOcEXSnqYYpuKRJJ7Q6HxN0lE6LApYJleCLCZjhvyIs
         MyjDMzDTfe8/aJfy1mwYRldLbPrqDT55NujV+ctV9v+Ix0H+F+ylsuVUOGzGnABWdPHU
         M+eYoY/RPb9b+dChjw+b3PeNtvTIjSTeDmlFb4N7LTyiqnNNjTycTqms7mbZVx0SkZHf
         8iS7z5CxWSp97Uo7qSH7QiLzNeav6Ev598irxKxm3QU+vtjZ9L38YsNp85gBVbdhH4Kg
         ZthzEfS49aqda/dd5GQk4HunB3f0TRhosFGMnbskgTSBcyurVSPZIOnas1YNpSuW8DAF
         5QGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GmXwDuGaXPIAjcN3yXogn03ChpqhhOxCUz2e/GVNFfo=;
        b=KS91qFc0UQ/qk65m2WAdpzQldsPpCMkMX7BykfOKQCwGx6oAhsYgQ1LbXJufIr4Z/D
         olT6+iSa5Bu5Krac9PTIygAVimyR0BMxKadFmPJcHp12dj08C0I9LEINBDp5A5wutaN3
         tDz3GS/vNHue2tmsisyKF7JoSwOlxBM7iEP5oAUGdP2smeKyOtXbvjND04lTKs8ggLg4
         dnr7+uRcO/3/aGokszcnCWxr4X8g/iVyFHn4I3Sa29ScJ4IsJOW9dNHD1ufYpsfbJpqO
         NqQZRzt+zTZWrfljitVlknNbGNoyImxVi34SA1WmyaEojrL75AOGtu/XLWDuSG9ZunyQ
         4lVA==
X-Gm-Message-State: AOAM533/kzOvlTiKXNiCG2O+xj6rUSV7d/W+78y0cdwn6yO5zKL5YLR8
        MQ5RPCcRagbl6T4BUZZL+tlsBtYucdxTcUYs
X-Google-Smtp-Source: ABdhPJxoR+71Tj9e+1xiUWIJ0C40rrnNfTZ+412aeSUxoD+l6FfYUgXSxVLpGmal4EUT50x995HnFA==
X-Received: by 2002:a17:90b:f85:: with SMTP id ft5mr1989136pjb.18.1644608434594;
        Fri, 11 Feb 2022 11:40:34 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id h6sm29994042pfk.110.2022.02.11.11.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 11:40:34 -0800 (PST)
Date:   Fri, 11 Feb 2022 11:40:31 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maxim Petrov <mmrmaximuzz@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] libnetlink: fix socket leak in
 rtnl_open_byproto()
Message-ID: <20220211114031.54f4f143@hermes.local>
In-Reply-To: <d376d06b-d1e3-c462-3a60-cc2e8ed7a147@gmail.com>
References: <d376d06b-d1e3-c462-3a60-cc2e8ed7a147@gmail.com>
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

On Tue, 8 Feb 2022 20:20:45 +0300
Maxim Petrov <mmrmaximuzz@gmail.com> wrote:

> rtnl_open_byproto() does not close the opened socket in case of errors, and the
> socket is returned to the caller in the `fd` field of the struct. However, none
> of the callers care about the socket, so close it in the function immediately to
> avoid any potential resource leaks.
> 
> Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>

Applied with reindent of commit message.
Checkpatch was complaining about long lines.
