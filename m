Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6BB5FB741
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 17:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiJKPbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 11:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbiJKPa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 11:30:29 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA351191E6;
        Tue, 11 Oct 2022 08:20:38 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 8so1205277qka.1;
        Tue, 11 Oct 2022 08:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f4lAh9xabXWHx1YV1USOQScCUvx4YzdCqINzyHiKlLw=;
        b=d4QqEKCKJ1nOzDp6+X8MwLTmcJ/4TcufnzwSLWq0ElH44V8FCY+8z62ZeQe15B24M7
         1SjvdP5PGKPkAq88qIO7Av9qYSjrjJ/GQRMN1eXSA544FFvuE4AcI2Vhy6XX9yOU8640
         5aIekDM2va69HH7fIuPTsBrqQMrtsYDno09XYnODvwI8ac0k3Hnd+NfJxP3HvfADkxtL
         EZ5e2i12J8eC9g4ziKTsqnFaULUSK5mNR+UbXjNSHL8mZ28R+d77ipct0hboADzsbNnN
         LZ52S+E4HSku6W/SRg9Mb1Fodbo9UyUjbyhu/8LTyLWzugWHBjnZ0J3JAYqZ+9vsu9gL
         2MKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f4lAh9xabXWHx1YV1USOQScCUvx4YzdCqINzyHiKlLw=;
        b=DTm7IBgt9mlYlhhYj3aFvArV26boqH0xSlBBU7MsLd0xshjD2vvQt9mASUzfLK4f/4
         KPiy2WosGmyrgfPi3ktr3hGqKEQKNURSph4TRBlxL52x1PbE5XxwhScwJuGRDGL3D/x4
         ex1SxkddHTrOw8oQWhNkNffJYRWpZw2LouIlqpQG9MUJ8WQhDO6o/DCtmoHDE5c8vQ1Y
         BiVxw4/jx6kvPHkfeFqdnnc78cx9VyINXSBU3CG5vVvTh8X46g3wzpB4D2qYXatCyooc
         qgbty2VCqtmAluLcl4DH9NT3Lh6w/LGRjKg8X2e/6wGj7wg9w6if/io53ZgYfVMTsXrU
         FlKQ==
X-Gm-Message-State: ACrzQf1gJJ2100dXm70fx9f+CUpHil+WQso25TZqltluKe17eX4tzIsG
        N2aOgHCkTJfR76tDT/01yKmt4cvN++/ZuXCSkj8=
X-Google-Smtp-Source: AMsMyM5SFNv1aflFd14AjYgLWyLY8Bgd835wUtgAxwoS3LMtBK6L7IoSaftMeQLh4cBIonDRCO5WunJKQWcBzdURtjA=
X-Received: by 2002:a05:620a:2893:b0:6bc:6ecd:2c44 with SMTP id
 j19-20020a05620a289300b006bc6ecd2c44mr16419149qkp.593.1665501581209; Tue, 11
 Oct 2022 08:19:41 -0700 (PDT)
MIME-Version: 1.0
References: <20221005171709.150520-1-xiyou.wangcong@gmail.com> <20221005171709.150520-2-xiyou.wangcong@gmail.com>
In-Reply-To: <20221005171709.150520-2-xiyou.wangcong@gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Tue, 11 Oct 2022 20:49:03 +0530
Message-ID: <CAP01T77f74ppZbn=qrJvz6suvAGR-4rcryXN1J_AcEp8LHe8sg@mail.gmail.com>
Subject: Re: [RFC Patch v6 1/5] bpf: Introduce rbtree map
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, yangpeihao@sjtu.edu.cn, toke@redhat.com,
        jhs@mojatatu.com, jiri@resnulli.us, bpf@vger.kernel.org,
        sdf@google.com, Cong Wang <cong.wang@bytedance.com>,
        davemarchevsky@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Oct 2022 at 22:53, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> Insert:
> bpf_map_update(&map, &key, &val, flag);
>
> Delete a specific key-val pair:
> bpf_map_delete_elem(&map, &key);
>
> Pop the minimum one:
> bpf_map_pop(&map, &val);
>
> Lookup:
> val = bpf_map_lookup_elem(&map, &key);
>
> Iterator:
> bpf_for_each_map_elem(&map, callback, key, val);
>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Instead of a dedicated BPF map and using kptr inside the map value, we
should probably lift Dave's series [0] adding the rbtree, and allow
linking sk_buff ctx directly into it. It would require recognising the
rb_node in sk_buff (or __sk_buff shadow struct) as a valid bpf_rb_node
similar to those in user allocated types. Overall it would be a much
better approach IMO and avoid having different rbtree implementations.
We would probably follow a similar approach for xdp_frame as well.

It can also be a union of bpf_rb_node, bpf_list_node, etc. Since the
type can only be in only one collection at once it would allow it to
be linked into different types of structures without wasting any
space.

[0]: https://lore.kernel.org/bpf/20220830172759.4069786-1-davemarchevsky@fb.com
