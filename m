Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91CD655C67
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfFYXhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:37:34 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34683 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfFYXhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:37:34 -0400
Received: by mail-qk1-f195.google.com with SMTP id t8so188118qkt.1
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=U5wJMMRMrBcHJ7qw5qqb6kUd+oW6NuaowHtVvA/G6ZA=;
        b=Ms3JFwf5G5uCsCTze8UZ0wttSEYv38ZI2i1K6XarnblYj5eVnDJijoQykqGgg2QW+p
         gP1oICKJqXGSwnhZXK7kDhD9j/hYvUZnwbqKXymb6BgIRz/8e+3ZgufHqoumsUzITXC1
         WixQPlZ/scGn5B0zFf2PfGNEEoZmODWGwuMNF0piRHzN7u9qU+/6QrKDNMAU80CoX6ZH
         rdyHStetkzEVeVrEPYI+BamIQwznijZeZ3WJOXy7d5LgsD1ic/SDgLYmV8S7REX54owN
         n94p0/PHHzpLhDSCkWuC5qo8MbghpiOP6X26If+cKzQ7ulphwrc095SbKK5oiG2vlICq
         a0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=U5wJMMRMrBcHJ7qw5qqb6kUd+oW6NuaowHtVvA/G6ZA=;
        b=eV/nQiQZl5KsrshiAIFsM9y0mYECY47XE/jn1zAgIjMO6lR6ec/sh3srYUDLLzUAy3
         i7uLo3oh8t/TJ6q3r0Pae3qSe4RiblKYZUaNXZChxGxb2FCnim+3pOVUJQT6c4ahtCTB
         cfPEfd6g1D2qyYHzVVaIpOklIamxPr0OfVOHGcQ2YZRY1oPFZiFShyX821SoxW/+pURY
         eY4rkDJUDrXPkQ2NzkAZ93nQCsj4Vq1J6fpgp8CdwMZQNcu9Cmrd3oeaG5mqKJSBr7Pz
         smEEnSA27eF3cgJmX+1P2IqLgJORSbejUdDTR/Q20TnET3yAZU0sRuJh/fNB4u4fzn8S
         Duuw==
X-Gm-Message-State: APjAAAXOzggYdBDI94RmbVwNUvCmTxf8ds+wyolVKdmQ7CYahJdtPwZY
        uG12jv7fPE8Oew6p70jR0F3BPO6JeXA=
X-Google-Smtp-Source: APXvYqxvB6xP7z3dCkxAgPz97Q0JDJcurr6iG3Xbks/Zh3MAELaHqe8BND6f3yXg5vvrBu0RVxIhig==
X-Received: by 2002:a37:8c7:: with SMTP id 190mr1241803qki.402.1561505853065;
        Tue, 25 Jun 2019 16:37:33 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 5sm7983345qkr.68.2019.06.25.16.37.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 16:37:32 -0700 (PDT)
Date:   Tue, 25 Jun 2019 16:37:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 10/18] ionic: Add management of rx filters
Message-ID: <20190625163729.617346e0@cakuba.netronome.com>
In-Reply-To: <20190620202424.23215-11-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190620202424.23215-11-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 13:24:16 -0700, Shannon Nelson wrote:
> +int ionic_rx_filter_save(struct lif *lif, u32 flow_id, u16 rxq_index,
> +			 u32 hash, struct ionic_admin_ctx *ctx)
> +{
> +	struct device *dev = lif->ionic->dev;
> +	struct hlist_head *head;
> +	struct rx_filter *f;
> +	unsigned int key;
> +
> +	f = devm_kzalloc(dev, sizeof(*f), GFP_KERNEL);
> +	if (!f)
> +		return -ENOMEM;
> +
> +	f->flow_id = flow_id;
> +	f->filter_id = le32_to_cpu(ctx->comp.rx_filter_add.filter_id);
> +	f->rxq_index = rxq_index;
> +	memcpy(&f->cmd, &ctx->cmd, sizeof(f->cmd));
> +
> +	INIT_HLIST_NODE(&f->by_hash);
> +	INIT_HLIST_NODE(&f->by_id);
> +
> +	switch (le16_to_cpu(f->cmd.match)) {
> +	case RX_FILTER_MATCH_VLAN:
> +		key = le16_to_cpu(f->cmd.vlan.vlan) & RX_FILTER_HLISTS_MASK;
> +		break;
> +	case RX_FILTER_MATCH_MAC:
> +		key = *(u32 *)f->cmd.mac.addr & RX_FILTER_HLISTS_MASK;
> +		break;
> +	case RX_FILTER_MATCH_MAC_VLAN:
> +		key = le16_to_cpu(f->cmd.mac_vlan.vlan) & RX_FILTER_HLISTS_MASK;
> +		break;
> +	default:

I know you use devm_kzalloc() but can't this potentially keep arbitrary
amounts of memory held until the device is removed (and it's the entire
device not just a LIF)?

> +		return -ENOTSUPP;

EOPNOTSUPP, please do not use ENOTSUPP in the drivers.  It's a high
error code, unknown to libc.  We should use EOPNOTSUPP or EINVAL.

> +	}
