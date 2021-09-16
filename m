Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E18E40D463
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 10:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234998AbhIPIWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 04:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhIPIWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 04:22:34 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523A5C061574;
        Thu, 16 Sep 2021 01:21:14 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id j18so6852438ioj.8;
        Thu, 16 Sep 2021 01:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=1wYqwqbL9hyxWAS0iuGjdiVoGK7Et/bVPFwALtk1Wf0=;
        b=C6zcXIxpLKreZZUpE9+OKTFTLCF3NHohH1awx+CKYpKaXYKBrOqYwAvZgbqnjfJylc
         kMMPCnskc8AiB3GZImcPle9eOk5WagpE5JXRDMJyoX0FN2Z1fJfJBRZ9e9HPkwFQAj45
         uMdjlNf+wDueUEtqGkgUzZXHn4Yng2mcmf4Bn9ZM2V/R+AaQIEICCTKc9xb12BL13fmI
         f2vjH2geRqHI/2E4WBGG2EKRAYHn3m1IwOqq/fu0Fhek8cHA/OAEtz9I9JTwSPvxeCsn
         ULo+NvB+0IuMtt3qFb07P4/xJOL2v50s65ekMZXY7m5JkOZpkJtZE9R4iOLr8NtKkVC2
         wj0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=1wYqwqbL9hyxWAS0iuGjdiVoGK7Et/bVPFwALtk1Wf0=;
        b=upXkmlffBo3uzu93nEYzADO3weLWON8pORwpUBf1xRcwxudKp0m9LJ6kHdz8H0JLTW
         IpVCQR8WptSbTmdx7gj2JPwOvaU0FJgMPiSJsRXtg8H0307Vy8RnKW7wfHlBKWL1KUdK
         iH9qUWqPgCKRtGUsyAqo6EZrUCUcRZZCBhDORJyLJnnzuub0d5HG+zGlPysp4Nrrxp4m
         jg6HGs8O2HkpFinz25bXDOx2/LOJpiN8JPNFwMd9yV1eenhd3ppKRqFjbfC3UkVb3dzo
         0KftJeuBhFIPqVasKgCjWSbK4kTfDVW9uDZB1pGR6VxweNcVxi1/x5Qiqfaf52rL+zJq
         drKQ==
X-Gm-Message-State: AOAM532klymzVBBv4ijfHnKCsbS6DYxnk+sgUbYVLMxsr0C4/2OF4mXN
        LNKvGb/gvdLhOF17KPR1Pzuv5BxKyXC/9Ub5oVOdX/Ac1Me2
X-Google-Smtp-Source: ABdhPJzIgh5T2RqzwOwUaL66yhZw/NNW/6yRZE9PtZu8zIvNE5wXN0rZSc39enS6H2zrZMOAUbjq21TVmqP7Pm27Ci0=
X-Received: by 2002:a6b:8bcf:: with SMTP id n198mr3425063iod.178.1631780473546;
 Thu, 16 Sep 2021 01:21:13 -0700 (PDT)
MIME-Version: 1.0
From:   Jinmeng Zhou <jjjinmeng.zhou@gmail.com>
Date:   Thu, 16 Sep 2021 16:21:02 +0800
Message-ID: <CAA-qYXgE=JXwHZm09eQB1=aDEp2ZZi3cf2GA2+NXQe_UtZkLdw@mail.gmail.com>
Subject: A missing check bug before calling ip_route_output_flow()
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        Jakub Kicinski <kuba@kernel.org>, maze@google.com,
        lorenzo@google.com
Cc:     netdev@vger.kernel.org, shenwenbosmile@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers,

hi, our team has found and reported a missing check bug on Linux
kernel v5.10.7 using static analysis.
We are looking forward to having more experts' eyes on this. Thank you!

Function ipv4_sk_update_pmtu() lacks a LSM check, a.k.a
security_sk_classify_flow(),
before calling ip_route_output_flow().

Specifically, we find that ip_route_output_flow() is used at 18 places in total.
In most cases, either the function is placed behind the security check
security_sk_classify_flow() or its last parameter is NULL.
(i.e., if the last parameter of ip_route_output_flow() is NULL,
usually, there may be no need to do a security check.)

However, we find only two usages in function ipv4_sk_update_pmtu(),
the last parameter is not NULL as well as no security check.


1. void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
2. {
3. ...
4. if (odst->obsolete && !odst->ops->check(odst, 0)) {
5. rt = ip_route_output_flow(sock_net(sk), &fl4, sk);
6. if (IS_ERR(rt))
7. goto out;
8.
9. new = true;
10. }
11.
12. __ip_rt_update_pmtu((struct rtable *)xfrm_dst_path(&rt->dst), &fl4, mtu);
13.
14. if (!dst_check(&rt->dst, 0)) {
15. if (new)
16. dst_release(&rt->dst);
17.
18. rt = ip_route_output_flow(sock_net(sk), &fl4, sk);
19. if (IS_ERR(rt))
20. goto out;
21.
22. new = true;
23. }
24. ...
25. }

ipv4_sk_update_pmtu() is called by 3 callers, ping_err(), raw_err(),
__udp4_lib_err().
They are likely to do the error handling.
Therefore, we think there is a missing check bug before calling
ip_route_output_flow().
---------------------------------------------------------------------------------
Original email:

> Thu, 6 May 2021 11:01:24 -0700 Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 6 May 2021 15:50:33 +0800 Jinmeng Zhou wrote:
> > hi, our team has found a missing check bug on Linux kernel v5.10.7 using
> static analysis.
> > We think there is a missing check bug in ip_route_output_key() before calling
> function ip_route_output_flow().
>
> Thank you for the report!
>
> > There is a check calls to security_sk_classify_flow() in function ip_route_newports().
> > 1. // check security_sk_classify_flow() ///////////////
> > 2. static inline struct rtable *ip_route_newports(struct flowi4 *fl4, struct rtable *rt,
> > 3.       __be16 orig_sport, __be16 orig_dport,
> > 4.       __be16 sport, __be16 dport,
> > 5.       struct sock *sk)
> > 6. {
> > 7. ...
> > 8.   security_sk_classify_flow(sk, flowi4_to_flowi(fl4));
> > 9.   return ip_route_output_flow(sock_net(sk), fl4, sk);
> > 10. ...
> > 11. }
> >
> > While, ip_route_output_key() does not have check.
> > 1. // no check ////////////////////////////////////
> > 2. static inline struct rtable *ip_route_output_key(struct net *net, struct flowi4 *flp)
> > 3. {
> > 4.   return ip_route_output_flow(net, flp, NULL);
> > 5. }
> >
> > On the path from user-reachable function to ip_route_output_key() also does not contain this check. There is a call chain:
> > nft_reject_ipv4_eval() =>
> > nf_send_reset() =>
>
> This path looks like ICMP reject path, so it's not run in a context of
> any process, I'm not sure security checks make sense in such context.
> But again please circulate the report more widely, add people who have
> touched the code in the past and relevant mailing lists.
>
> > ip_route_me_harder() =>
> > ip_route_output_key()
> >
> > 1. static const struct nft_expr_ops nft_reject_ipv4_ops = {
> > 2.
> > 3.   .eval = nft_reject_ipv4_eval,
> > 4.
> > 5. };
> > 6. static int __init nft_reject_ipv4_module_init(void)
> > 7. {
> > 8.   return nft_register_expr(&nft_reject_ipv4_type);
> > 9. }
> > 10. module_init(nft_reject_ipv4_module_init);
> >
> > Therefore we think the buggy function can be triggered.
> >
> > Thanks!
> >
> >
> > Best regards,
> > Jinmeng Zhou


Thanks again!

Best regards,
Jinmeng Zhou
