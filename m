Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E1C7B64D
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 01:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfG3Xjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 19:39:55 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40904 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfG3Xjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 19:39:55 -0400
Received: by mail-pf1-f193.google.com with SMTP id p184so30654434pfp.7
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 16:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iqvZDML2l21CYTb52tiOQrKirgo1YQUTk9eG8GGpcuQ=;
        b=b9FLRrXGsz8WFr2e4NE8MFuFv+jEhNrkVTJoKLtyK99EJ5Wk+jlE1vWPP2VUYYW0hA
         pOE0g8S3b1bYskO4ucyUHf7bSMi+W5o8Ie+A36YYlAHiJc94iStzbDnuzPSPHejRJHey
         +wgJaO2VU7CmIJ0ypmx8RJdblsCusOU70qZDCnBntYT55cf6YE6rq2CGcYmsfex4ikSI
         kyA4OnBgvn+T7LV8dUb5xCWaRvbBK7zYaS0YSmGMX4keD9RWEvMwakQFXUAm3I85Fvp8
         NHV3tyQis4yJRVYI/jLoASwmBn6iW4PHn0wDZW+F6HTnOecvTfpzHus02+LZdKP0nZJn
         t2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iqvZDML2l21CYTb52tiOQrKirgo1YQUTk9eG8GGpcuQ=;
        b=c+K9sJ09WGXVtlOUGQccmsETO5BA8giBkMDI0mGP/7qRvGEpq8Owe6gbmC3g85UqSt
         ne8WwShLszGmWlG9A0FyqX0SQS26cnyR62qTmKg21zzr3ngAxPL5G1K2QM6MtfNl8AK6
         PMXtmuvNingaMq0UfVLu1480r+lQYChN/M1KuDdxustN9mfUzuVc7ghO0HeKZGuIYaHt
         3Fy9FJFi9ColZ8gYdqgBKY8q9WNSCggSdUCbcFagT30mOVgtzrR0xNzrc/eNMEaLU6qG
         OwUfN09tRenrMqtaBLmTaeOqiKuYBf/+G86ytmEEwmRmLGQIv9amlxSjiCxU0S0tco1F
         XuxQ==
X-Gm-Message-State: APjAAAW+5NiL3vxtuJFd8UGzNzJerFMSvZbnvIdrcDkbD8tSbEFHU8/y
        9WvTnlzpLgs/M+2NoYhdY+E=
X-Google-Smtp-Source: APXvYqzaG/mzTmYTH5C+in0BJiG115GHNuAHWzfwvWyjeTDxATTrB9OCINahmnHJLiT2XyVTEFNpRA==
X-Received: by 2002:a17:90a:9604:: with SMTP id v4mr13043pjo.66.1564529994077;
        Tue, 30 Jul 2019 16:39:54 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h6sm63232776pfb.20.2019.07.30.16.39.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 16:39:53 -0700 (PDT)
Date:   Tue, 30 Jul 2019 16:39:47 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v4 net-next 15/19] ionic: Add netdev-event handling
Message-ID: <20190730163947.3e730f25@hermes.lan>
In-Reply-To: <20190722214023.9513-16-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
        <20190722214023.9513-16-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Jul 2019 14:40:19 -0700
Shannon Nelson <snelson@pensando.io> wrote:

> +
> +static void ionic_lif_set_netdev_info(struct lif *lif)
> +{
> +	struct ionic_admin_ctx ctx = {
> +		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
> +		.cmd.lif_setattr = {
> +			.opcode = CMD_OPCODE_LIF_SETATTR,
> +			.index = cpu_to_le16(lif->index),
> +			.attr = IONIC_LIF_ATTR_NAME,
> +		},
> +	};
> +
> +	strlcpy(ctx.cmd.lif_setattr.name, lif->netdev->name,
> +		sizeof(ctx.cmd.lif_setattr.name));
> +
> +	dev_info(lif->ionic->dev, "NETDEV_CHANGENAME %s %s\n",
> +		 lif->name, ctx.cmd.lif_setattr.name);
> +

There is already a kernel message for this. Repeating the same thing in the
driver is redundant.
