Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAB692410
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 15:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfHSNBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 09:01:09 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:35238 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbfHSNBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 09:01:09 -0400
Received: by mail-vs1-f68.google.com with SMTP id q16so1105793vsm.2;
        Mon, 19 Aug 2019 06:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZePDTxUfjMjKLHjhwy9E6JOUCjVAy0prTpZjzd31lbc=;
        b=N4bCc1bVSQzLWboEBPRBuQtP3MqpZJu3+NUnPcykdFkfWohJqvIhQV+++Pkwt2yo+R
         nrBD5GI1/aVmOCOYppUGA6zfoUb36QV+942xfqRypVLUyHq8AoN/z4cZYB/9yqpdmibH
         uBJpBc/EMd6fwjWtkOKebPcPQjHrBaIH8zKFwEimQ86o3oDnwr2NgvXkoiSYUesZt7X6
         CMvWa2WeB7ucdLg785KGo2o5bVOs4XokRWJ49g42qCkiYjC8IdlAUcbEQ9F0yPVIs8hO
         vIxuL/Puq7CrslDz65DtIMkW1ws+Qha5s2HRj9YBUadRzqNzBc4wf9Ypcuqhq9ytE/NQ
         kx9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZePDTxUfjMjKLHjhwy9E6JOUCjVAy0prTpZjzd31lbc=;
        b=gWuLL9lJh5NBolOSNXJJ0c2U4PQDhCityqK7Nd1gB902IfnwmDifTeK85jPnnbl8AV
         MXdsNkSKyQSBhvLk+FHepEhPUUi/kony2vo+fv7yNRwViJ9KshoB4r8N9SsOUnzLpdSR
         qthm3IWM2BbqxE3XWw5HsFvjju3kvBFnUNAcLgt91gMlXla+exP117eBxf0089/zd95+
         xv/4BGEvU91SlrhZNg+g6uMLxqLewyWkhEw4DPLLOAtD41A2XuDKalF4dlFQ/gL77Q04
         RYwkkoj0A3rRILNVsiqnK/F3xipwZosJ+ELy1TuPBGDT7zrmbNqzdLVCmdIXK8ApyAta
         jV/A==
X-Gm-Message-State: APjAAAVRpIGx/A/G+m7+4IO2I2uLmKqwrn4e9OQc9xGV5jf4WdlaZ1T0
        ukFWFPXgYmCx48T7hhHkh2AK0VHxZ9U2zU4SiYI=
X-Google-Smtp-Source: APXvYqxP0H91DjJU9+nWXUKVwORmVnF97Dfobj+YLJ+6hAK7mKDYgbzVa/qutDn6JoWUgpFjfklEsR7Fwpqgc1JfUwU=
X-Received: by 2002:a67:8b8a:: with SMTP id n132mr14074612vsd.90.1566219667950;
 Mon, 19 Aug 2019 06:01:07 -0700 (PDT)
MIME-Version: 1.0
References: <1565684495-2454-1-git-send-email-wenwen@cs.uga.edu>
In-Reply-To: <1565684495-2454-1-git-send-email-wenwen@cs.uga.edu>
From:   Moshe Shemesh <moshes20.il@gmail.com>
Date:   Mon, 19 Aug 2019 16:00:53 +0300
Message-ID: <CALBF4T_xmmAyTpPRfuC0a_C+TpX5xbA9+U1JxUJ6p1RvUFjGHQ@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5: Fix a memory leak bug
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:MELLANOX MLX5 core VPI driver" <netdev@vger.kernel.org>,
        "open list:MELLANOX MLX5 core VPI driver" 
        <linux-rdma@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please don't change that.
On command timeout we don't release ent, since the FW event on
completion can occur after timeout, so it is released on the
completion handler mlx5_cmd_comp_handler().
See commit 73dd3a4839c1d ("net/mlx5: Avoid using pending command
interface slots").

On Tue, Aug 13, 2019 at 11:22 AM Wenwen Wang <wenwen@cs.uga.edu> wrote:
>
> In mlx5_cmd_invoke(), 'ent' is allocated through kzalloc() in alloc_cmd().
> After the work is queued, wait_func() is invoked to wait the completion of
> the work. If wait_func() returns -ETIMEDOUT, the following execution will
> be terminated. However, the allocated 'ent' is not deallocated on this
> program path, leading to a memory leak bug.
>
> To fix the above issue, free 'ent' before returning the error.
>
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> index 8cdd7e6..90cdb9a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> @@ -1036,7 +1036,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *in,
>
>         err = wait_func(dev, ent);
>         if (err == -ETIMEDOUT)
> -               goto out;
> +               goto out_free;
>
>         ds = ent->ts2 - ent->ts1;
>         op = MLX5_GET(mbox_in, in->first.data, opcode);
> --
> 2.7.4
>
