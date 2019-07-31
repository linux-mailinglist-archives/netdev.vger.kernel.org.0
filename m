Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472A97CB44
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 19:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfGaR6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 13:58:51 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34330 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbfGaR6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 13:58:50 -0400
Received: by mail-yw1-f67.google.com with SMTP id q128so25298397ywc.1
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 10:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kle/jIqFf1IBE1ChD4Ekr3jmYwXu/5ocoCRxbcDWju8=;
        b=eE8FsgX7scWFsv3ZMwBZQ7axOCEi+d10t8w6hFWXlivn3IMzmsGuTmyWHXdxPCwRKv
         o+y8WWvSNtpaGElI7rzmnGJO4ic98MrxUyhjnEiDbhAjk+2YVXO1iRYlrnxtxQFqiCQ2
         DQPgEFSaZS6nf3TaVpT9xi7XiX5dhLwrV+3ag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kle/jIqFf1IBE1ChD4Ekr3jmYwXu/5ocoCRxbcDWju8=;
        b=S8Znv+PAS6lg+S9M+kMce8SVJzdMlu/99wN2bnCD0RY3jIUj3f7cmoJ+FH12uUL0oi
         1Si2OyBiHxZz7JxkaWILkpl8u9izhDtJHqwQWsaB/nTCUs7gecU5LJTRZ1AOzmsgqkQ2
         1/HXS8YXNW+Ybob51OdsJ019LvWQGNNptnLNQJ6GpmSP9tBvlHP31wmEDWrZQcAf8xQh
         WdCWiAayOTWDuRWghvWcHMdtJ/wx/YUr99vkvaxRKn6ibp2+JNQPU2KG2QyHz0QDoaLa
         5YYR7hsOvOy4qbcAuKfFLuD3Y4PW0zv3EYwLXywojQr/4NQWQ1sJyibw33FYuH1H+06r
         Lz6A==
X-Gm-Message-State: APjAAAXoSseWAeeoUkE58TVQu7QrqJDScjpAcbHCZWLviPcLHuSOGdS5
        kIN1GtSEimNd3u0lZzHERnS4v5JmDT7gJK0zYVayzw==
X-Google-Smtp-Source: APXvYqwWX1s49fHEyXmj/CofKnB+QyLedV3m2fr3vgSBgPElXrzY9e4fYwGTyrZZNe4IbQYauEVPw9LEIb0HRbPGyEM=
X-Received: by 2002:a81:9a01:: with SMTP id r1mr70879517ywg.490.1564595929908;
 Wed, 31 Jul 2019 10:58:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190731122224.1003-1-hslester96@gmail.com>
In-Reply-To: <20190731122224.1003-1-hslester96@gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 31 Jul 2019 10:58:38 -0700
Message-ID: <CACKFLinuFebDgJN=BgK5e-bNaFqNpk61teva0=2xMH6R_iT39g@mail.gmail.com>
Subject: Re: [PATCH 2/2] cnic: Use refcount_t for refcount
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 5:22 AM Chuhong Yuan <hslester96@gmail.com> wrote:

>  static void cnic_ctx_wr(struct cnic_dev *dev, u32 cid_addr, u32 off, u32 val)
> @@ -494,7 +494,7 @@ int cnic_register_driver(int ulp_type, struct cnic_ulp_ops *ulp_ops)
>         }
>         read_unlock(&cnic_dev_lock);
>
> -       atomic_set(&ulp_ops->ref_count, 0);
> +       refcount_set(&ulp_ops->ref_count, 0);
>         rcu_assign_pointer(cnic_ulp_tbl[ulp_type], ulp_ops);
>         mutex_unlock(&cnic_lock);
>

Willem's comment applies here too.  The driver needs to be modified to
count from 1 to use refcount_t.

Thanks.
