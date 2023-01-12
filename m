Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB3D6679C0
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjALPpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240430AbjALPpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:45:13 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2DCE85
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 07:36:14 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso19552719pjl.2
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 07:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AoAOW8YnhW4elfXYGAwjnnLaTgWYwivE9o+kPAJCPfs=;
        b=fJYemohf6lG6oXeYLKv62/TtScQa+5O4Ef7RMfpCpAXKSTNlpFgknHmVwaqEXvAv1U
         sr3j9ED71FuE/PRSovytxOynFVLVDgpXMDIriB4JjFnIVVfzEU8Buhpo5vigaYi+Q6Rt
         XESJTTyDZtLU695itE+Y+IQwrmt0+U+bDL4jsS02QqyoTL8fc273+9KLvFLil69lcYcp
         pnF1ojk6IHf/uYNm40ZQgS11Ty3xLYOum7Yxz1IsRHMqIULkh63F+PGY49spqDvWddoV
         A+4qsI6C9bXTUi6yPZQVmSUrkof/qOARvw2z06YrDi150fhHFJQaNQzLxS53LNMFr8GS
         /pQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AoAOW8YnhW4elfXYGAwjnnLaTgWYwivE9o+kPAJCPfs=;
        b=T6riXSiBYQpTADNLSPMXl/PWPUu6Lfkbzh4YktEmWRoIIlhmXJ7uzkUYwMat51tken
         s7cF1XsYrq+Ci/qWn8SJVozDsDBdrluhJXuOh40zmDz+2MZiJhRHYcwfO8i2PLGX0RXN
         C3yfRqOl/xugmyOdu/F/jqYGTD49M6OQqV1y4Ia6SHjvAN9Jh/GO2rQ0BghSeNWjkLvS
         68WZo3SVwGiSCtBs9ISyt16X/yY6AImF/XFkkLQ/LiEf2fLQZJt2vYZHejY40l+CH3Yn
         vQsZPo9eY3ABCHff/9YkHvokEMaNTAXKTZVXdVPs5I7flXhe8F2WSnMFL9Qg/7qm1mIR
         quwQ==
X-Gm-Message-State: AFqh2kpGouhNvjZbzni6ceFFO1k5dYSVpICJ/EgnX60amrPKUPxrO4EB
        u2iG8hAMojC/eKkT75akbYAdYUcrKdy8jcAvkxg=
X-Google-Smtp-Source: AMrXdXuj6wpX6PRy3uQ9V5FOtyGprWSvJNUbGsyE7ivyAa+3L0VdbaNM8aku4PakNpbYtYbNAczytXGzl1hNfOLAoeg=
X-Received: by 2002:a17:90b:98:b0:226:412e:2de3 with SMTP id
 bb24-20020a17090b009800b00226412e2de3mr4369417pjb.178.1673537773324; Thu, 12
 Jan 2023 07:36:13 -0800 (PST)
MIME-Version: 1.0
References: <20230110115359.10163-1-lanhao@huawei.com> <f2e3a02cd2a584aa1ed036e90c5c71764e0b8373.camel@gmail.com>
 <7a93e4f9-0db4-a520-e5fd-8e52d860c2cf@huawei.com>
In-Reply-To: <7a93e4f9-0db4-a520-e5fd-8e52d860c2cf@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 12 Jan 2023 07:36:01 -0800
Message-ID: <CAKgT0Uc2vLv+R2DbKf5yAoLZ5nD3+F7yw65SLSvERVtiy4RKRA@mail.gmail.com>
Subject: Re: [PATCH net] net: hns3: fix wrong use of rss size during VF rss config
To:     Hao Lan <lanhao@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, edumazet@google.com, pabeni@redhat.com,
        richardcochran@gmail.com, shenjian15@huawei.com,
        wangjie125@huawei.com, netdev@vger.kernel.org
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

On Wed, Jan 11, 2023 at 6:56 PM Hao Lan <lanhao@huawei.com> wrote:
>
>
>
> On 2023/1/12 0:31, Alexander H Duyck wrote:
> > On Tue, 2023-01-10 at 19:53 +0800, Hao Lan wrote:
> >> From: Jie Wang <wangjie125@huawei.com>
> >>
> >> Currently, it used old rss size to get current tc mode. As a result, the
> >> rss size is updated, but the tc mode is still configured based on the old
> >> rss size.
> >>
> >> So this patch fixes it by using the new rss size in both process.
> >>
> >> Fixes: 93969dc14fcd ("net: hns3: refactor VF rss init APIs with new common rss init APIs")
> >> Signed-off-by: Jie Wang <wangjie125@huawei.com>
> >> Signed-off-by: Hao Lan <lanhao@huawei.com>
> >> ---
> >>  drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> >> index 081bd2c3f289..e84e5be8e59e 100644
> >> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> >> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
> >> @@ -3130,7 +3130,7 @@ static int hclgevf_set_channels(struct hnae3_handle *handle, u32 new_tqps_num,
> >>
> >>      hclgevf_update_rss_size(handle, new_tqps_num);
> >>
> >> -    hclge_comm_get_rss_tc_info(cur_rss_size, hdev->hw_tc_map,
> >> +    hclge_comm_get_rss_tc_info(kinfo->rss_size, hdev->hw_tc_map,
> >>                                 tc_offset, tc_valid, tc_size);
> >>      ret = hclge_comm_set_rss_tc_mode(&hdev->hw.hw, tc_offset,
> >>                                       tc_valid, tc_size);
> >
> > I can see how this was confused. It isn't really clear that handle is
> > being used to update the kinfo->rss_size value. Maybe think about
> > adding a comment to prevent someone from reverting this without
> > realizing that? It might also be useful to do a follow-on patch for
> > net-next that renames cur_rss_size to orig_rss_size to make it more
> > obvious that the value is changing.
> >
> > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> > .
> >
> Hi Alexander Duyck,
> Thank you for your reviewed.And thank you for your valuable advice.
> Would it be better if we changed it to the following.
>
> -       u16 cur_rss_size = kinfo->rss_size;
> -       u16 cur_tqps = kinfo->num_tqps;
> +       u16 orig_rss_size = kinfo->rss_size;
> +       u16 orig_tqps = kinfo->num_tqps;
>         u32 *rss_indir;
>         unsigned int i;
>         int ret;
>
>         hclgevf_update_rss_size(handle, new_tqps_num);
>
> -       hclge_comm_get_rss_tc_info(cur_rss_size, hdev->hw_tc_map,
> +       /* RSS size will be updated after hclgevf_update_rss_size,
> +        * so we use kinfo->rss_size instead of orig_rss_size.
> +        */
> +       hclge_comm_get_rss_tc_info(kinfo->rss_size, hdev->hw_tc_map,

Yes, something like this would make it more obvious that these fields
are changing.
