Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC2053CD7B
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 18:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344020AbiFCQs1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Jun 2022 12:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbiFCQs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 12:48:26 -0400
Received: from relay4.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5EF4D62F
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 09:48:24 -0700 (PDT)
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay07.hostedemail.com (Postfix) with ESMTP id 839042171B;
        Fri,  3 Jun 2022 16:48:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id 2C8C620018;
        Fri,  3 Jun 2022 16:48:20 +0000 (UTC)
Message-ID: <495f2924138069abaf49269b2c3bd1e4f5f4362e.camel@perches.com>
Subject: Re: [PATCH v2] libbpf: Fix is_pow_of_2
From:   Joe Perches <joe@perches.com>
To:     Ian Rogers <irogers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yuze Chi <chiyuze@google.com>
Date:   Fri, 03 Jun 2022 09:48:19 -0700
In-Reply-To: <CAP-5=fVhVLWg+c=WJyOD8FByg_4n6V0SLSLnaw7K0J=-oNnuaA@mail.gmail.com>
References: <20220603055156.2830463-1-irogers@google.com>
         <CAP-5=fVhVLWg+c=WJyOD8FByg_4n6V0SLSLnaw7K0J=-oNnuaA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        KHOP_HELO_FCRDNS,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: rzbx35joaqpa7bowsa6rnrkez3mwwwaa
X-Rspamd-Server: rspamout06
X-Rspamd-Queue-Id: 2C8C620018
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1984zn9Oltf4R7aHUeyWpSPbJhORpgNnjg=
X-HE-Tag: 1654274900-542024
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-06-02 at 22:57 -0700, Ian Rogers wrote:
> On Thu, Jun 2, 2022 at 10:52 PM Ian Rogers <irogers@google.com> wrote:
> > From: Yuze Chi <chiyuze@google.com>
[]
> > diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
[]
> > @@ -580,4 +580,9 @@ struct bpf_link * usdt_manager_attach_usdt(struct usdt_manager *man,
> >                                            const char *usdt_provider, const char *usdt_name,
> >                                            __u64 usdt_cookie);
> > 
> > +static inline bool is_pow_of_2(size_t x)
> > +{
> > +       return x && (x & (x - 1)) == 0;
> > +}
> > +
> >  #endif /* __LIBBPF_LIBBPF_INTERNAL_H */

If speed of execution is a potential issue, maybe:

#if __has_builtin(__builtin_popcount)
	return __builtin_popcount(x) == 1;
#else
	return x && (x & (x-1)) == 0;
#endif

