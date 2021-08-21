Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5853F3B9C
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 19:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhHURQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 13:16:47 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:51548 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhHURQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 13:16:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629566167; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=MLXw2kAV40fUYj05/3m6TBzD/fnzpbaaqB86lj9wxNQ=;
 b=adVTl/bAR/vARRJz3qajtU/nH+62wvkd4mioA1552wZ9LGg9yFDwYRkvguZtsgda0CkO/zHw
 XJxThJNZhs3fobUmKNX+hA/1o4fl3tfMfCFO1MoBp2q+CMq5V8jo06+zubEKQEp09Ad0s0/d
 Ls8bvFKcCHcKrOlUjALaBzxxwGc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 612134cb89fbdf3ffe78282e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 21 Aug 2021 17:15:55
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 398BEC43619; Sat, 21 Aug 2021 17:15:54 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AEA07C4360C;
        Sat, 21 Aug 2021 17:15:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org AEA07C4360C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] ipw2x00: Avoid field-overflowing memcpy()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210819202825.3545692-2-keescook@chromium.org>
References: <20210819202825.3545692-2-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     netdev@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210821171554.398BEC43619@smtp.codeaurora.org>
Date:   Sat, 21 Aug 2021 17:15:54 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> libipw_read_qos_param_element() copies a struct libipw_info_element
> into a struct libipw_qos_information_element, but is actually wanting to
> copy into the larger struct libipw_qos_parameter_info (the contents of
> ac_params_record[] is later examined). Refactor the routine to perform
> centralized checks, and copy the entire contents directly (since the id
> and len members match the elementID and length members):
> 
> struct libipw_info_element {
>         u8 id;
>         u8 len;
>         u8 data[];
> } __packed;
> 
> struct libipw_qos_information_element {
>         u8 elementID;
>         u8 length;
>         u8 qui[QOS_OUI_LEN];
>         u8 qui_type;
>         u8 qui_subtype;
>         u8 version;
>         u8 ac_info;
> } __packed;
> 
> struct libipw_qos_parameter_info {
>         struct libipw_qos_information_element info_element;
>         u8 reserved;
>         struct libipw_qos_ac_parameter ac_params_record[QOS_QUEUE_NUM];
> } __packed;
> 
> Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

2 patches applied to wireless-drivers-next.git, thanks.

d6b6d1bb80be ipw2x00: Avoid field-overflowing memcpy()
92276c592a6b ray_cs: Split memcpy() to avoid bounds check warning

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210819202825.3545692-2-keescook@chromium.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

