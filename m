Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEEE1043B
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 05:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfEADeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 23:34:50 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35335 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfEADet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 23:34:49 -0400
Received: by mail-qk1-f195.google.com with SMTP id b7so269536qkl.2;
        Tue, 30 Apr 2019 20:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jk+8U7QA9efUk7PdDFFL2OAkZbP5CGTZXo88lisginU=;
        b=cSFkqCD136TZbEh94XJ1PI/Y10lKEqLMZwDGTbMLJEJK5+5XWHuwOFZVytzUxxKD7+
         uYU/EREQFfZ9qaZ3KaRRZQXtn7pAniz+QQcAYwnDeq11OpDUQL/Q92UWgU9W+YR2pNmY
         gE35F+r/8qeHgl29hjDARFLnunWAAHB42pgmBWXODBZTurVJt8d3+TF9WsYLCk6dnPVL
         PAz+GxtHViICcvbWdSi+zdOluOT22H1p2QVfVXq2BUgpGrFpN8N58WsQm98q+0kop4IU
         zrMjdauiuDtzd4RSIZf9tCWV08692ox42N5mTz1C5mOurndFXaskYhLkQ5M2fPjANXY3
         09sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=jk+8U7QA9efUk7PdDFFL2OAkZbP5CGTZXo88lisginU=;
        b=LtvRWamqVz1wf1cquWGELThxJNG5Ffmp6IDZWLWcISojfmwnGfcK8X3XBGoFpm8BBJ
         SIzUryFpVif9ePvV7awmJAZ5cAhV3dUaZ54etQNxPIvMiNZqvMflNRLiuXNGrWKhCMjb
         nNThmrkOUGxzxCz5tvrphx86Y2dYWhmHjkqVKRHwi9MYgEOleqtVmQvP/iFkh/DmmE9Y
         A2rt0MZ90vjXCRMV5rOtiWS0TfHsG771AsHe+MJC1cv6Tj0CsZxi0tvS1lvhCG+OUrIV
         rLDfU3yDI2LWEVIMo+3Xolmaadqe+UH3a9NbjCl72D+kFk2E47+1zsFdutdlXszrgam3
         6+QA==
X-Gm-Message-State: APjAAAXQktKixZsOLumpMmdx2RtMZ0j9kGI1of3XF+Ih8CnUKwgFUULn
        Coyjk4uBfI67qtee3xkKdpAROpZLYLBddFLaR8VMP3x3
X-Google-Smtp-Source: APXvYqxICf7TJVx+3xoalQoV0BeL/Vz0ZxTc9nPKTKHuTVn2V0SBFVC8if3/mtlvMTwrCzRkOkShDdPHTeZEIZilYXg=
X-Received: by 2002:ae9:df03:: with SMTP id t3mr1369206qkf.346.1556681688088;
 Tue, 30 Apr 2019 20:34:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190430124536.7734-1-bjorn.topel@gmail.com> <20190430124536.7734-3-bjorn.topel@gmail.com>
In-Reply-To: <20190430124536.7734-3-bjorn.topel@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Tue, 30 Apr 2019 20:34:12 -0700
Message-ID: <CALDO+Saow5HY3xTrjrQaoacbLM-gnBDEzP=5QNd0VhkTHo+dyw@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] libbpf: proper XSKMAP cleanup
To:     bpf@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 5:46 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> The bpf_map_update_elem() function, when used on an XSKMAP, will fail
> if not a valid AF_XDP socket is passed as value. Therefore, this is
> function cannot be used to clear the XSKMAP. Instead, the
> bpf_map_delete_elem() function should be used for that.
>
> This patch also simplifies the code by breaking up
> xsk_update_bpf_maps() into three smaller functions.
>
> Reported-by: William Tu <u9012063@gmail.com>
> Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---

Thank you.
Tested-by: William Tu <u9012063@gmail.com>

>  tools/lib/bpf/xsk.c | 115 +++++++++++++++++++++++---------------------
>  1 file changed, 60 insertions(+), 55 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index af5f310ecca1..c2e6da464504 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -386,21 +386,17 @@ static void xsk_delete_bpf_maps(struct xsk_socket *=
xsk)
>  {
>         close(xsk->qidconf_map_fd);
>         close(xsk->xsks_map_fd);
> +       xsk->qidconf_map_fd =3D -1;
> +       xsk->xsks_map_fd =3D -1;
>  }
>
> -static int xsk_update_bpf_maps(struct xsk_socket *xsk, int qidconf_value=
,
> -                              int xsks_value)
> +static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
>  {
> -       bool qidconf_map_updated =3D false, xsks_map_updated =3D false;
> +       __u32 i, *map_ids, num_maps, prog_len =3D sizeof(struct bpf_prog_=
info);
> +       __u32 map_len =3D sizeof(struct bpf_map_info);
>         struct bpf_prog_info prog_info =3D {};
> -       __u32 prog_len =3D sizeof(prog_info);
>         struct bpf_map_info map_info;
> -       __u32 map_len =3D sizeof(map_info);
> -       __u32 *map_ids;
> -       int reset_value =3D 0;
> -       __u32 num_maps;
> -       unsigned int i;
> -       int err;
> +       int fd, err;
>
>         err =3D bpf_obj_get_info_by_fd(xsk->prog_fd, &prog_info, &prog_le=
n);
>         if (err)
> @@ -421,66 +417,71 @@ static int xsk_update_bpf_maps(struct xsk_socket *x=
sk, int qidconf_value,
>                 goto out_map_ids;
>
>         for (i =3D 0; i < prog_info.nr_map_ids; i++) {
> -               int fd;
> +               if (xsk->qidconf_map_fd !=3D -1 && xsk->xsks_map_fd !=3D =
-1)
> +                       break;
>
>                 fd =3D bpf_map_get_fd_by_id(map_ids[i]);
> -               if (fd < 0) {
> -                       err =3D -errno;
> -                       goto out_maps;
> -               }
> +               if (fd < 0)
> +                       continue;
>
>                 err =3D bpf_obj_get_info_by_fd(fd, &map_info, &map_len);
> -               if (err)
> -                       goto out_maps;
> +               if (err) {
> +                       close(fd);
> +                       continue;
> +               }
>
>                 if (!strcmp(map_info.name, "qidconf_map")) {
> -                       err =3D bpf_map_update_elem(fd, &xsk->queue_id,
> -                                                 &qidconf_value, 0);
> -                       if (err)
> -                               goto out_maps;
> -                       qidconf_map_updated =3D true;
>                         xsk->qidconf_map_fd =3D fd;
> -               } else if (!strcmp(map_info.name, "xsks_map")) {
> -                       err =3D bpf_map_update_elem(fd, &xsk->queue_id,
> -                                                 &xsks_value, 0);
> -                       if (err)
> -                               goto out_maps;
> -                       xsks_map_updated =3D true;
> +                       continue;
> +               }
> +
> +               if (!strcmp(map_info.name, "xsks_map")) {
>                         xsk->xsks_map_fd =3D fd;
> +                       continue;
>                 }
>
> -               if (qidconf_map_updated && xsks_map_updated)
> -                       break;
> +               close(fd);
>         }
>
> -       if (!(qidconf_map_updated && xsks_map_updated)) {
> +       err =3D 0;
> +       if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0) {
>                 err =3D -ENOENT;
> -               goto out_maps;
> +               xsk_delete_bpf_maps(xsk);
>         }
>
> -       err =3D 0;
> -       goto out_success;
> -
> -out_maps:
> -       if (qidconf_map_updated)
> -               (void)bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queu=
e_id,
> -                                         &reset_value, 0);
> -       if (xsks_map_updated)
> -               (void)bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_i=
d,
> -                                         &reset_value, 0);
> -out_success:
> -       if (qidconf_map_updated)
> -               close(xsk->qidconf_map_fd);
> -       if (xsks_map_updated)
> -               close(xsk->xsks_map_fd);
>  out_map_ids:
>         free(map_ids);
>         return err;
>  }
>
> +static void xsk_clear_bpf_maps(struct xsk_socket *xsk)
> +{
> +       int qid =3D false;
> +
> +       (void)bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &q=
id, 0);
> +       (void)bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
> +}
> +
> +static int xsk_set_bpf_maps(struct xsk_socket *xsk)
> +{
> +       int qid =3D true, fd =3D xsk->fd, err;
> +
> +       err =3D bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, =
&qid, 0);
> +       if (err)
> +               goto out;
> +
> +       err =3D bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id, &fd=
, 0);
> +       if (err)
> +               goto out;
> +
> +       return 0;
> +out:
> +       xsk_clear_bpf_maps(xsk);
> +       return err;
> +}
> +
>  static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>  {
> -       bool prog_attached =3D false;
>         __u32 prog_id =3D 0;
>         int err;
>
> @@ -490,7 +491,6 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>                 return err;
>
>         if (!prog_id) {
> -               prog_attached =3D true;
>                 err =3D xsk_create_bpf_maps(xsk);
>                 if (err)
>                         return err;
> @@ -500,20 +500,21 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xs=
k)
>                         goto out_maps;
>         } else {
>                 xsk->prog_fd =3D bpf_prog_get_fd_by_id(prog_id);
> +               err =3D xsk_lookup_bpf_maps(xsk);
> +               if (err)
> +                       goto out_load;
>         }
>
> -       err =3D xsk_update_bpf_maps(xsk, true, xsk->fd);
> +       err =3D xsk_set_bpf_maps(xsk);
>         if (err)
>                 goto out_load;
>
>         return 0;
>
>  out_load:
> -       if (prog_attached)
> -               close(xsk->prog_fd);
> +       close(xsk->prog_fd);
>  out_maps:
> -       if (prog_attached)
> -               xsk_delete_bpf_maps(xsk);
> +       xsk_delete_bpf_maps(xsk);
>         return err;
>  }
>
> @@ -641,6 +642,9 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, c=
onst char *ifname,
>                 goto out_mmap_tx;
>         }
>
> +       xsk->qidconf_map_fd =3D -1;
> +       xsk->xsks_map_fd =3D -1;
> +
>         if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_L=
OAD)) {
>                 err =3D xsk_setup_xdp_prog(xsk);
>                 if (err)
> @@ -705,7 +709,8 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>         if (!xsk)
>                 return;
>
> -       (void)xsk_update_bpf_maps(xsk, 0, 0);
> +       xsk_clear_bpf_maps(xsk);
> +       xsk_delete_bpf_maps(xsk);
>
>         optlen =3D sizeof(off);
>         err =3D getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &opt=
len);
> --
> 2.20.1
>
