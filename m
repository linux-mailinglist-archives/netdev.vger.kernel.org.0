Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3B85B2A84
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 01:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiIHXpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 19:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiIHXo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 19:44:59 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B145143D
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 16:44:57 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id a129so165122vsc.0
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 16:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Y7TWOtDpon5Nttq0NPO+sGf6ZvFDO5uaqBl6d0L6ZOA=;
        b=HFQZlKkjbX7wGP4tkFuL5B23GQLh56nqk4VIx9k2YoQ/Ds0n1iD9o3hfy0c9stpYq7
         Wmievp83EWVegnKdrGPf0TgbZdlJAQdrZDTWGNnO4H1Sq0AMWNiZpBXU9ZKzRpDy0ciU
         iTsfKd4CS8HSHjfZ6ZLUqbgWS/hJ5td6adUI6Wppp7Nw7qQsxaNwGfBNU8kc+pB8A/cE
         N/yCZ+xYbXMbghz76yROrj6PAAiotjX2lkcrNL35h3fvZfCV1Q6pPcIfv9MaKeOfhTTy
         WZYWGyEB/jnr/wVQSV/Y/z7MpOnlc+onegXDdb08xmwQdIMpUxjSzlUYDd12g/b2rqUE
         ixOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Y7TWOtDpon5Nttq0NPO+sGf6ZvFDO5uaqBl6d0L6ZOA=;
        b=sIW1soL/P/Q/SaxsWeZ1HwBSLfZF3nO/Dr/Ex5NlWp/mVDIETL6Io1YHTgZv3UY2ju
         07XiXZlD00lYWcsQeSblbgIMa8DYOsBPcrS9/vTcZjsZnkK0Yz7twNwX9WVZ4ay/6q3U
         b4tfjsQvcWce7Xr8w/8BeFDVl9nqKT24zYtcRwx1As9RHWaedXPHmYJDUYXxKDy5cYHQ
         ocjq2Cuf5vJ2BHW4JXyKKkoJ+9Z4AQ7MEL2tubdPSLhng73LDWwn39mCB3d61px7Vvth
         +6LoXXtAt0xfReirBo1/ZK7bw8XhYB20Dw1Zhnu8tdRzfX8LVtesviKNwVlOHsG69H3P
         TURw==
X-Gm-Message-State: ACgBeo0D5q9l6fnYL01kouzVdPjR/sJpUAi2fefktqgCFn57ikYqx6s+
        dOjNKuOs/vu67EtDINGLZmfEIj4CbUmb7g15eZ09zg==
X-Google-Smtp-Source: AA6agR6fCuZSA22FZAqMML4OzLwnMQXRGaa1//x9SdMthC42hxy7ww05w5TNZCCPLILYHro8Pk7iyLyyGK22vHXEty8=
X-Received: by 2002:a05:6102:40d:b0:398:2420:b4e7 with SMTP id
 d13-20020a056102040d00b003982420b4e7mr3622694vsq.46.1662680696153; Thu, 08
 Sep 2022 16:44:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662678623.git.zhuyifei@google.com> <97288b66a44c984cb5514ca7390ca0cf9c30275f.1662678623.git.zhuyifei@google.com>
 <e1648c86-7859-a7c8-4474-83c826cbb464@linux.dev>
In-Reply-To: <e1648c86-7859-a7c8-4474-83c826cbb464@linux.dev>
From:   YiFei Zhu <zhuyifei@google.com>
Date:   Thu, 8 Sep 2022 16:44:45 -0700
Message-ID: <CAA-VZPnTBOOAxu+VqupzDqej_wheXYbOGxG0nuV+eMPqS35GKQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 3/3] selftests/bpf: Ensure cgroup/connect{4,6}
 programs can bind unpriv ICMP ping
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 8, 2022 at 4:32 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 9/8/22 4:16 PM, YiFei Zhu wrote:
> > +void test_connect_ping(void)
> > +{
> > +     struct connect_ping *skel;
> > +     int cgroup_fd;
> > +
> > +     if (!ASSERT_OK(unshare(CLONE_NEWNET | CLONE_NEWNS), "unshare"))
> > +             return;
> > +
> > +     /* overmount sysfs, and making original sysfs private so overmount
> > +      * does not propagate to other mntns.
> > +      */
> > +     if (!ASSERT_OK(mount("none", "/sys", NULL, MS_PRIVATE, NULL),
> > +                    "remount-private-sys"))
> > +             return;
> > +     if (!ASSERT_OK(mount("sysfs", "/sys", "sysfs", 0, NULL),
> > +                    "mount-sys"))
> > +             return;
> > +     if (!ASSERT_OK(mount("bpffs", "/sys/fs/bpf", "bpf", 0, NULL),
> > +                    "mount-bpf"))
> > +             goto clean_mount;
> > +
> > +     if (!ASSERT_OK(system("ip link set dev lo up"), "lo-up"))
> > +             goto clean_mount;
> > +     if (!ASSERT_OK(system("ip addr add 1.1.1.1 dev lo"), "lo-addr-v4"))
> > +             goto clean_mount;
> > +     if (!ASSERT_OK(system("ip -6 addr add 2001:db8::1 dev lo"), "lo-addr-v6"))
> > +             goto clean_mount;
> > +     if (write_sysctl("/proc/sys/net/ipv4/ping_group_range", "0 0"))
> > +             goto clean_mount;
> > +
> > +     cgroup_fd = test__join_cgroup("/connect_ping");
> > +     if (!ASSERT_GE(cgroup_fd, 0, "cg-create"))
> > +             goto clean_mount;
> > +
> > +     skel = connect_ping__open_and_load();
> > +     if (!ASSERT_OK_PTR(skel, "skel-load"))
> > +             goto close_cgroup;
> > +     skel->links.connect_v4_prog =
> > +             bpf_program__attach_cgroup(skel->progs.connect_v4_prog, cgroup_fd);
> > +     if (!ASSERT_OK_PTR(skel->links.connect_v4_prog, "cg-attach-v4"))
> > +             goto close_cgroup;
>
> connect_ping__destroy() is also needed in this error path.
>
> I had already mentioned that in v2.  I went back to v2 and noticed my
> editor some how merged my reply with the previous quoted line ">".  A
> similar thing happened in my recent replies also.  I hope it appears
> fine this time.

Oops, I missed that and thought that was part of a quote. Let me fix
that and send a v4.

> > +     skel->links.connect_v6_prog =
> > +             bpf_program__attach_cgroup(skel->progs.connect_v6_prog, cgroup_fd);
> > +     if (!ASSERT_OK_PTR(skel->links.connect_v6_prog, "cg-attach-v6"))
> > +             goto close_cgroup;
>
> Same here.
