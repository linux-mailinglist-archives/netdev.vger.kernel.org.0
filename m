Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 819CD9A334
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394122AbfHVWoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:44:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49934 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394112AbfHVWoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:44:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 084AB15394C8C;
        Thu, 22 Aug 2019 15:43:58 -0700 (PDT)
Date:   Thu, 22 Aug 2019 15:43:58 -0700 (PDT)
Message-Id: <20190822.154358.2175623534462502224.davem@davemloft.net>
To:     zhang.lin16@zte.com.cn
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, willemb@google.com,
        edumazet@google.com, deepa.kernel@gmail.com, arnd@arndb.de,
        dh.herrmann@gmail.com, gnault@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        jiang.xuexin@zte.com.cn
Subject: Re: [PATCH v2] sock: fix potential memory leak in proto_register()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566348158-43942-1-git-send-email-zhang.lin16@zte.com.cn>
References: <1566348158-43942-1-git-send-email-zhang.lin16@zte.com.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 15:43:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhanglin <zhang.lin16@zte.com.cn>
Date: Wed, 21 Aug 2019 08:42:38 +0800

> @@ -3243,18 +3245,24 @@ int proto_register(struct proto *prot, int alloc_slab)
>  	}
>  
>  	mutex_lock(&proto_list_mutex);
> +	if (assign_proto_idx(prot)) {
> +		mutex_unlock(&proto_list_mutex);
> +		goto out_free_timewait_sock_slab_name;
> +	}

Propagate the error code properly please.

