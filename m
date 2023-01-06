Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F0A660580
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 18:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbjAFRRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 12:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235714AbjAFRRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 12:17:30 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E843D6E
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 09:17:29 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 124so1539455pfy.0
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 09:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TavTUbONX2+yXfbTWhYMTZaU5crQvqDDzZMkJ5klCoI=;
        b=OQ2i+YjNeDuVeemoCKcA2XSQdxATDnzDlf0RB/QbImUC7WJyGCcbS+x3ItHv4p3bSv
         YtxcAO9wJ4U1ZRz0pWW0kdxuj3iVn5LCbwY9VXEc7SoFVY4Ze4VN/J86L/Rbi4fdQ4ia
         kZvZbvJQ7T8FOXHZOUs1OjOneoLgnPKriCppNEFspUmNHyuAXeq93f8Nha/QLLXXAnBq
         9w9xVh0G2hrl7s1FC1d0QezYm/Qge3h8cpEjHDWd+xIR8NJIjmhy5oDNQ5IuXJ2E3f+u
         ruL+MhSEBDfwy5449lBWB+myk7pp+6o1q4jlikuYrUb1HA3LP1/eqL/vSQDsyAmD669O
         mmDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TavTUbONX2+yXfbTWhYMTZaU5crQvqDDzZMkJ5klCoI=;
        b=YxgOmd7ubPdVxP6k8Tps7dQ4GBayypqBi76+Gqj2pFMY5gGmLK5ewOwOc8t4i0ZoaU
         yD/PwT+GWrpcBMczer88mNOMHe7suoEFOAdl51N29UGjO9Pq7e9PWl4lTLOsF+Ved2Iv
         szeGCiHoXeKavQo/JNi7A5nrxPH9UZUXFVWSWQ/vFvGSmvNaAleACF0eYBcizCWRkw6o
         NZC5RNM7JTStISrBONSb7tLBQhEKqHfLEsKtl0WMq/CIK3NHaBjMUuip9rHCdJ7XFkiT
         FquFVGEdjE30dJg0cnFC0gCshfWvFoVBJhOkVQ8H3qKJXgBzYb5cF2sa69ebaJU+pfsO
         tedw==
X-Gm-Message-State: AFqh2kq4F5Lmmq6ZziioCAgOPfdz3GYtStE8ljpzujzk/Le2R5MEr6NO
        /04BZzC6qlG49d2u63KR4sDM/7ProeqPBcvFYN7cWA==
X-Google-Smtp-Source: AMrXdXvZ8opWqDUM60+7TMJoKaRUq+N+CT1X9WhXI5/EMF0PYpXOXugqaMscHIisifaLKZRR3tVlDWwEC+73ayGQIAs=
X-Received: by 2002:a63:9d0a:0:b0:49f:478d:a72c with SMTP id
 i10-20020a639d0a000000b0049f478da72cmr1706861pgd.250.1673025448721; Fri, 06
 Jan 2023 09:17:28 -0800 (PST)
MIME-Version: 1.0
References: <20230104215949.529093-1-sdf@google.com> <20230104215949.529093-8-sdf@google.com>
 <bd002756-3295-b708-e304-976d42dbf121@linux.dev>
In-Reply-To: <bd002756-3295-b708-e304-976d42dbf121@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 6 Jan 2023 09:17:17 -0800
Message-ID: <CAKH8qBvaTUH+gSYRXpmuLBS90=pAumvZ6dPyzdFrBndpEx3+sQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 07/17] bpf: XDP metadata RX kfuncs
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 5, 2023 at 4:48 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 1/4/23 1:59 PM, Stanislav Fomichev wrote:
> > +void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
> > +{
> > +     const struct xdp_metadata_ops *ops;
> > +     void *p = NULL;
> > +
> > +     /* We don't hold bpf_devs_lock while resolving several
> > +      * kfuncs and can race with the unregister_netdevice().
> > +      * We rely on bpf_dev_bound_match() check at attach
> > +      * to render this program unusable.
> > +      */
> > +     down_read(&bpf_devs_lock);
> > +     if (!prog->aux->offload || !prog->aux->offload->netdev)
>
> nit. !prog->aux->offload->netdev check is not needed. Testing
> !prog->aux->offload should be as good.

Yeah, true, will remove, thanks!
