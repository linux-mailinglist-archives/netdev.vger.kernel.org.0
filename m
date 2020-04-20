Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5511B018D
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 08:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgDTGXP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Apr 2020 02:23:15 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:34246 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgDTGXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 02:23:15 -0400
Received: by mail-il1-f195.google.com with SMTP id w6so4281891ilg.1
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 23:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DW7UHzkcGMwY+JrSQtAwwwCpV4u6nEyqHcyU8VHqxxk=;
        b=Mzu9OSFTFfOPDS53qPIqxGxscnqhFmwTHJybV0v4sVzRZMb4motLnio8LpWMRQfyWT
         /bmS8r0K9oDbewjGqqYC7zxYAHqbm10xoPQ3y1bh/yuZMrmE5WWNvSTqjqLBwsE8y494
         4Axdn5LO5W3pi2PoWL1aQcG8Ys6tHCizTrW3JI/42HRpEaAe1y+XvEjXld5mJKaTnxdn
         +UJUwAPXuNs1+nRvdu7a8Z4EXfJ/ggk5dIsJv7kC67Jb3w5jCWqy8Pnu0vcSVaDFPVBg
         xn+P+2q06e0bu35JAxf/I/7NaSMM6r7g0/qxCkGz2lNsAHib+1Bbal74OVxGQzVPJJwe
         6MSQ==
X-Gm-Message-State: AGi0PuZLazfIbRLcsDCiX3u/bbRqxcnD1bPR92aDKfdpOLttBRRXf7DJ
        E88Wr/nbKMJu5bsbFsp4SGZGWjlcQibkEl4aBWpX5gUb
X-Google-Smtp-Source: APiQypL0SuQE4WNC/EFHHA94kcJi6BtSvmLA2p7PPD4VKE454YwoDu7rP31tTPYbQ0wnYgbuBGxu4dGtUtx4VNYi87Y=
X-Received: by 2002:a92:d484:: with SMTP id p4mr13856881ilg.307.1587363794870;
 Sun, 19 Apr 2020 23:23:14 -0700 (PDT)
MIME-Version: 1.0
References: <5b93ede1.2832e.171957ca60f.Coremail.yilin@iie.ac.cn>
In-Reply-To: <5b93ede1.2832e.171957ca60f.Coremail.yilin@iie.ac.cn>
From:   Zhiyun Qian <zhiyunq@cs.ucr.edu>
Date:   Mon, 20 Apr 2020 06:23:03 +0000
Message-ID: <CALvgte-xH-O6GuhD94o6GR5ko2hSj0vWViR8XFAp3+fd=eJn_Q@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_drivers=EF=BC=9A_target=EF=BC=9A_iscsi=3A_cxgbit=3A_is_there_exi?=
        =?UTF-8?Q?st_a_memleak_in_cxgbit=5Fcreate=5Fserver4=3F?=
To:     =?UTF-8?B?5piT5p6X?= <yilin@iie.ac.cn>
Cc:     vishal@chelsio.com, "csong@cs.ucr.edu" <csong@cs.ucr.edu>,
        "yiqiuping@gmail.com" <yiqiuping@gmail.com>,
        jian liu <liujian6@iie.ac.cn>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-Zhiyun

On Mon, Apr 20, 2020 at 2:48 AM 易林 <yilin@iie.ac.cn> wrote:
>
> static int
> cxgbit_create_server4(struct cxgbit_device *cdev, unsigned int stid,
>                       struct cxgbit_np *cnp)
> {
>         struct sockaddr_in *sin = (struct sockaddr_in *)
>                                    &amp;cnp-&gt;com.local_addr;
>         int ret;
>
>         pr_debug("%s: dev = %s; stid = %u; sin_port = %u\n",
>                  __func__, cdev-&gt;lldi.ports[0]-&gt;name, stid, sin-&gt;sin_port);
>
>         cxgbit_get_cnp(cnp);
>         cxgbit_init_wr_wait(&amp;cnp-&gt;com.wr_wait);
>
>         ret = cxgb4_create_server(cdev-&gt;lldi.ports[0],
>                                   stid, sin-&gt;sin_addr.s_addr,
>                                   sin-&gt;sin_port, 0,
>                                   cdev-&gt;lldi.rxq_ids[0]);
>         if (!ret)
>                 ret = cxgbit_wait_for_reply(cdev,
>                                             &amp;cnp-&gt;com.wr_wait,
>                                             0, 10, __func__);
>         else if (ret &gt; 0)
>                 ret = net_xmit_errno(ret);
>         else
>                 cxgbit_put_cnp(cnp);
>
>         if (ret)
>                 pr_err("create server failed err %d stid %d laddr %pI4 lport %d\n",
>                        ret, stid, &amp;sin-&gt;sin_addr, ntohs(sin-&gt;sin_port));
>         return ret;
> }
> what if cxgb4_create_server return a &gt;0 value, the cnp reference wouldn't be released. Or, when cxgb4_create_server  return &gt;0 value, cnp has been released somewhere.

"&gt:0"? typo?
