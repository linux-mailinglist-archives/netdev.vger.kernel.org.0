Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA8C598655
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730741AbfHUVNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 17:13:14 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46090 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbfHUVNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 17:13:14 -0400
Received: by mail-qk1-f194.google.com with SMTP id p13so3159563qkg.13
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 14:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gpl298X3IY84tJs6L3n/n0rk3SP4aPONuyod94Yazcc=;
        b=B1hay4B9FaWEnfzb+3CQAey9tMm8c85TUqF4Lb1rICEFaXhG7HTVYIi3Mn1fwVljym
         ekHUzGSSKt4cEBDVrMGJHAcBFuS8/fJOpxVHcKEGlqGTzmlE2SB8BxMlDfTiz26irA/V
         CGflQPNGRi6kzIIZ+sLUJ9Jg9OcDduoWzaK9YHs1W/wGF51Il05tvp+8WybTZapllcyO
         0Se+7qKjdV8aISiM1av/Xk707uQsV51TEtCOGWmr+178aqWfS5if5vX8Pg5XLJqWqT8n
         dEawfrSo+tDOcOzVqbxy81pN3o26L9ejHtitgz32tmSach+qvz4Dx8f9oNrPOF7WWqX7
         f4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gpl298X3IY84tJs6L3n/n0rk3SP4aPONuyod94Yazcc=;
        b=HnXhgFUclL3YY4BbGpNqIZKiqeTUVQ7kBGQhK/s8y04xw14CD0/IfF8cTbmb1wxWZm
         fl8jYVNo7oRBEXjwcBXHhe16zMxhESgMe+8967w31cG2ck0XfCCDHYZ4ay6G2hUbiYkA
         /idSHlm6iHH2EwgWO4XzKvRP+mXfKY0/krDhtqMaHX9CY1dGRNa3NDXgp+HcVSJKLA/n
         FVhxxWZOYW+bzcz/1EcjM3IGxoqxwMnquoLyAXilduyxnvYg2121aNbNneCfv4TXOhxJ
         CHG+kauiAV6k6bhHyjTu2hSQL8+4UysWyZDKfXeTy0Zjuz3infLggbxMjGdQ/5toT4k/
         ri0w==
X-Gm-Message-State: APjAAAW+vXzGXe/p4dlx70DkiiX4mHn9JExjZ+3KNy7jleX2IogLeSUg
        rZs7TCtEDs0DHtUlFibfDh90TQ==
X-Google-Smtp-Source: APXvYqwHSxs5CuI8w98hixMlM/1Co3tU8F7IgAVJcWrY2chVdk3gMSVYEadb/oQTHjkJpDTjfwz/cg==
X-Received: by 2002:a37:6109:: with SMTP id v9mr32997910qkb.432.1566421993102;
        Wed, 21 Aug 2019 14:13:13 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y26sm13524235qta.39.2019.08.21.14.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 14:13:13 -0700 (PDT)
Date:   Wed, 21 Aug 2019 14:13:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 24/38] cls_u32: Convert tc_u_common->handle_idr to
 XArray
Message-ID: <20190821141308.54313c30@cakuba.netronome.com>
In-Reply-To: <20190820223259.22348-25-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
        <20190820223259.22348-25-willy@infradead.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 15:32:45 -0700, Matthew Wilcox wrote:
> @@ -305,8 +306,12 @@ static void *u32_get(struct tcf_proto *tp, u32 handle)
>  /* Protected by rtnl lock */
>  static u32 gen_new_htid(struct tc_u_common *tp_c, struct tc_u_hnode *ptr)
>  {
> -	int id = idr_alloc_cyclic(&tp_c->handle_idr, ptr, 1, 0x7FF, GFP_KERNEL);
> -	if (id < 0)
> +	int err;
> +	u32 id;
> +
> +	err = xa_alloc_cyclic(&tp_c->ht_xa, &id, ptr, XA_LIMIT(0, 0x7ff),
> +			&tp_c->ht_next, GFP_KERNEL);

nit: indentation seems off here and a couple of other places.
