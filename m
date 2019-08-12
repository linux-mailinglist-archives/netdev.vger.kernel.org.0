Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B98FC8A147
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 16:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfHLOhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 10:37:24 -0400
Received: from ajax.cs.uga.edu ([128.192.4.6]:56548 "EHLO ajax.cs.uga.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfHLOhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 10:37:24 -0400
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
        (authenticated bits=0)
        by ajax.cs.uga.edu (8.14.4/8.14.4) with ESMTP id x7CEbLnw046789
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 12 Aug 2019 10:37:22 -0400
Received: by mail-lj1-f174.google.com with SMTP id r9so98508484ljg.5;
        Mon, 12 Aug 2019 07:37:22 -0700 (PDT)
X-Gm-Message-State: APjAAAUq4y/aUsIswoRcA+NYjGPlUsoFngqk9beTMkpc7wNU561pK+Ts
        7F2Hrk5hqsL12tGCbzfonO8VhlAZuqIGNGzLpc8=
X-Google-Smtp-Source: APXvYqwHjweXtAnZiiWTex2gV+573FnnCM4Bigr6V0xRAj2PUVm5tKqJ0aEvN23cJIb7jhc7vNyJ3r75T6pPOtCVtDA=
X-Received: by 2002:a2e:3c12:: with SMTP id j18mr3801850lja.50.1565620641004;
 Mon, 12 Aug 2019 07:37:21 -0700 (PDT)
MIME-Version: 1.0
References: <1565591765-6461-1-git-send-email-wenwen@cs.uga.edu> <75e09920-4ae3-0a19-4c2a-112d16bb81a5@mellanox.com>
In-Reply-To: <75e09920-4ae3-0a19-4c2a-112d16bb81a5@mellanox.com>
From:   Wenwen Wang <wenwen@cs.uga.edu>
Date:   Mon, 12 Aug 2019 10:36:44 -0400
X-Gmail-Original-Message-ID: <CAAa=b7dk37o-z=XNTCFOFMuR=G1_ig1bv+YRJaNwJSkgfQTVPw@mail.gmail.com>
Message-ID: <CAAa=b7dk37o-z=XNTCFOFMuR=G1_ig1bv+YRJaNwJSkgfQTVPw@mail.gmail.com>
Subject: Re: [PATCH] net/mlx4_en: fix a memory leak bug
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "open list:MELLANOX ETHERNET DRIVER (mlx4_en)" 
        <netdev@vger.kernel.org>,
        "open list:MELLANOX MLX4 core VPI driver" 
        <linux-rdma@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Wenwen Wang <wenwen@cs.uga.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 5:05 AM Tariq Toukan <tariqt@mellanox.com> wrote:
>
> Hi Wenwen,
>
> Thanks for your patch.
>
> On 8/12/2019 9:36 AM, Wenwen Wang wrote:
> > In mlx4_en_config_rss_steer(), 'rss_map->indir_qp' is allocated through
> > kzalloc(). After that, mlx4_qp_alloc() is invoked to configure RSS
> > indirection. However, if mlx4_qp_alloc() fails, the allocated
> > 'rss_map->indir_qp' is not deallocated, leading to a memory leak bug.
> >
> > To fix the above issue, add the 'mlx4_err' label to free
> > 'rss_map->indir_qp'.
> >
>
> Add a Fixes line.
>
> > Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu> > ---
> >   drivers/net/ethernet/mellanox/mlx4/en_rx.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > index 6c01314..9476dbd 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > @@ -1187,7 +1187,7 @@ int mlx4_en_config_rss_steer(struct mlx4_en_priv *priv)
> >       err = mlx4_qp_alloc(mdev->dev, priv->base_qpn, rss_map->indir_qp);
> >       if (err) {
> >               en_err(priv, "Failed to allocate RSS indirection QP\n");
> > -             goto rss_err;
> > +             goto mlx4_err;
> >       }
> >
> >       rss_map->indir_qp->event = mlx4_en_sqp_event;
> > @@ -1241,6 +1241,7 @@ int mlx4_en_config_rss_steer(struct mlx4_en_priv *priv)
> >                      MLX4_QP_STATE_RST, NULL, 0, 0, rss_map->indir_qp);
> >       mlx4_qp_remove(mdev->dev, rss_map->indir_qp);
> >       mlx4_qp_free(mdev->dev, rss_map->indir_qp);
> > +mlx4_err:
>
> I don't like the label name. It's too general and not informative.
> Maybe qp_alloc_err?

Thanks! I will rework the patch.

Wenwen
