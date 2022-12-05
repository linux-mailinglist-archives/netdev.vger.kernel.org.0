Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE531642268
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 05:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiLEE5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 23:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbiLEE5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 23:57:05 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220FAE02D
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 20:57:05 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id j196so13107687ybj.2
        for <netdev@vger.kernel.org>; Sun, 04 Dec 2022 20:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UD2XpZ2LJD1muTcjqRuCqsm2mEoyJLeqsIAqiriwPkw=;
        b=d6+XtmAhE6dW+Q5JtmFpwxPtlm9+hDdVErdt7Ukfl9gNCmZBQtxUwF+p2GRglaMYt+
         vOxxQoBReO8TFXs3CvQjc5eD0ghPTsZiuC4On4UBii0dwwlCbZJWJQ9/+k+lBvF1JAaF
         PjWAwQNSJKWRae+kpuZnhRz72WFU1gaL/J6HG8jsM+dF51oDpTFtFwVdKr/+/F8irhCs
         s8F/y0cAi4sXPhjuCXW94tnZeJ1hBU0ddDd1jkiWMlACu+aWnr9iXWcTH2fog9Gv0Kw/
         SefnZwvToL0rNJgZgKLfnkBUtzxSgKaFRzeitcg4Hqzi+Xqcqxm2op4WKWc9VuIzZ42A
         TbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UD2XpZ2LJD1muTcjqRuCqsm2mEoyJLeqsIAqiriwPkw=;
        b=8P8lIcPNXgcY77m2YJQ5hQ9VMlsQt/y9QUdc3yaazpMqCfQGcNQ9kq3e56zBpyHYPd
         VgC+bXcfyRnOzgWv6K8RKAq1NAuIRzKM8n+9dTJEWKA96uj0Cu8ClcFnEdBa/GDo4TC7
         PWqHPOlWf7AP0wYYH/idBfn5/ZysME+bTFAz+VAN5dtPgoy+iwTkopegc+pRr7BCkaPA
         pwei0T+wspNghxAN5lyx9XCQcpqMTJhQjhUy26ycXHiAUA0epUdww66iif12EiZ041zO
         rKr/pV00xSSXPm5XtGSBsqZyROyzn8GHg9anio+R5Nj4pPTdOix/YWC0dGkBsDvnEMud
         zuWw==
X-Gm-Message-State: ANoB5pnLmHIleiiPXv+BmvmLje4van+hJ1ExcNjHzQzw47cmqfLq+0NA
        ilNLMOnP/ywrxeubhTbwac1qLbH15npe7dKXvKQMvQ==
X-Google-Smtp-Source: AA0mqf67qWT6un2xetd+3bnoKxghNsJy7SiqksEoSZ7BKC+RowArlKjaM7n+Xi7BRt0eVGcz5THxdLCy7XpZgivbldQ=
X-Received: by 2002:a25:24d:0:b0:6fd:2917:cf60 with SMTP id
 74-20020a25024d000000b006fd2917cf60mr11840119ybc.427.1670216224053; Sun, 04
 Dec 2022 20:57:04 -0800 (PST)
MIME-Version: 1.0
References: <20221128154456.689326-1-pctammela@mojatatu.com> <20221128154456.689326-2-pctammela@mojatatu.com>
In-Reply-To: <20221128154456.689326-2-pctammela@mojatatu.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 5 Dec 2022 05:56:52 +0100
Message-ID: <CANn89iL2Oyq3GhudP9FVawWyswYj+2QB0iQHKFf2GH8DZ8HeTg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net/sched: add retpoline wrapper for tc
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 4:45 PM Pedro Tammela <pctammela@gmail.com> wrote:
>
> On kernels compiled with CONFIG_RETPOLINE and CONFIG_NET_TC_INDIRECT_WRAPPER,
> optimize actions and filters that are compiled as built-ins into a direct call.
> The calls are ordered alphabetically, but new ones should be ideally
> added last.
>
> On subsequent patches we expose the classifiers and actions functions
> and wire up the wrapper into tc.
>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---


> +static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
> +                          struct tcf_result *res)

Perhaps remove the __ prefix, since there is not yet an  __tc_act() and tc_act()

> +
> +static inline int __tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
> +                               struct tcf_result *res)

Same remark, the __ prefix seems not necessary.
