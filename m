Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39084149E84
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 05:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgA0EvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 23:51:20 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41413 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbgA0EvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 23:51:20 -0500
Received: by mail-lj1-f196.google.com with SMTP id h23so9195149ljc.8
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 20:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ki4qkh/EfXLaWX1kthGeQwsKn9IruVl+TYtZj0UrKyU=;
        b=U//igtUWoFyyELHTVlGKdFqSiTxHYARt4eonqvc0fMPoFtNVQbchKaXZ+pLFapetXd
         4NGk9LZCdjjEP4v1aUtF8c4WkxHcB0o/BtEkUgdXceZwIMSQfsT1ZgM44VMZ4nntGFjD
         6rgw1ROF7cTqXgDm4RMi1FSMuggyxv6tAZ09Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ki4qkh/EfXLaWX1kthGeQwsKn9IruVl+TYtZj0UrKyU=;
        b=PF9IPlYoLhwj72XD+Lepd7fkAvn5OftTzfndI0h3zeh5FsOhx1bl95CBRmBBNtIZWI
         0BWHD11lxV/p2O9WvPlySg6feNAwAcyuW2mQx4DgwMjGDvZflnCu/qyeGke8j5I5E7B3
         AB2HOWSBF9NsQt/Z/4CS+jr9F0jhbTD1ZMBJesaCTG2tdnYVX/K5nSq4fvogbtzbzS2l
         EVo8oeyiza7wrDUmpeU/CMxEQkybqc4O1M+9obeq2dkKge9iCsjCHAcFkXIl+Ds0N4dc
         Vmcvk0M+BAOiU1A7VsDaZ84Kwfm9Izrkd17Cc1hNEGUPX7mztZ1shP4GNfBFDSWinvWd
         aIpg==
X-Gm-Message-State: APjAAAWMHsK5Y77ERTnf3OiGNktdPUXfz6LEsQF8VLPoJQXmytPpvKc5
        +2ufXB6omBRSHv/zSJDsSqFlSNmDWzm9Z/raFhK06w==
X-Google-Smtp-Source: APXvYqzkZirp1xw2zFO8Hc9gj8Umjgc4GmRAb015bQiMYrG8fETr+jwqh5sg8znyllQsPiyl9pUkaUaU2N2HCMRS9ag=
X-Received: by 2002:a2e:2e11:: with SMTP id u17mr8853761lju.117.1580100677325;
 Sun, 26 Jan 2020 20:51:17 -0800 (PST)
MIME-Version: 1.0
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
 <1580029390-32760-10-git-send-email-michael.chan@broadcom.com> <20200126113219.GI2254@nanopsycho.orion>
In-Reply-To: <20200126113219.GI2254@nanopsycho.orion>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon, 27 Jan 2020 10:21:06 +0530
Message-ID: <CAACQVJpR8OoifuMiArgoSqyYDxiKeZi0B29h7TrX+sktFys-zw@mail.gmail.com>
Subject: Re: [PATCH net-next 09/16] bnxt_en: Refactor bnxt_dl_register()
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 5:02 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Sun, Jan 26, 2020 at 10:03:03AM CET, michael.chan@broadcom.com wrote:
> >From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> >
> >Define bnxt_dl_params_register() and bnxt_dl_params_unregister()
> >functions and move params register/unregister code to these newly
> >defined functions. This patch is in preparation to register
> >devlink irrespective of firmware spec. version in the next patch.
> >
> >Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> >Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> >---
> > drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 60 ++++++++++++++---------
> > 1 file changed, 36 insertions(+), 24 deletions(-)
> >
> >diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> >index 0c3d224..9253eed 100644
> >--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> >+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> >@@ -485,6 +485,38 @@ static const struct devlink_param bnxt_dl_params[] = {
> > static const struct devlink_param bnxt_dl_port_params[] = {
> > };
> >
> >+static int bnxt_dl_params_register(struct bnxt *bp)
> >+{
> >+      int rc;
> >+
> >+      rc = devlink_params_register(bp->dl, bnxt_dl_params,
> >+                                   ARRAY_SIZE(bnxt_dl_params));
> >+      if (rc) {
> >+              netdev_warn(bp->dev, "devlink_params_register failed. rc=%d",
> >+                          rc);
> >+              return rc;
> >+      }
> >+      rc = devlink_port_params_register(&bp->dl_port, bnxt_dl_port_params,
> >+                                        ARRAY_SIZE(bnxt_dl_port_params));
>
> Wait, this assumes that you have 1:1 devlink:devlink_port setup. Is that
> correct? Don't you have other devlink_ports for eswitch representors
> that have params?
Yes Jiri, this assumes 1:1 setup. Our driver does not register params for VFs.
It will register params only for PFs.

This patch is refactoring of code and moving params_registers to a new function,
which will not be called for VFs.

There is a check for PF in bnxt_dl_register() and return before calling
bnxt_dl_params_register(), if check fails.
>
>
> >+      if (rc) {
> >+              netdev_err(bp->dev, "devlink_port_params_register failed");
> >+              devlink_params_unregister(bp->dl, bnxt_dl_params,
> >+                                        ARRAY_SIZE(bnxt_dl_params));
> >+              return rc;
> >+      }
> >+      devlink_params_publish(bp->dl);
> >+
> >+      return 0;
> >+}
> >+
> >+static void bnxt_dl_params_unregister(struct bnxt *bp)
> >+{
> >+      devlink_params_unregister(bp->dl, bnxt_dl_params,
> >+                                ARRAY_SIZE(bnxt_dl_params));
> >+      devlink_port_params_unregister(&bp->dl_port, bnxt_dl_port_params,
> >+                                     ARRAY_SIZE(bnxt_dl_port_params));
> >+}
> >+
> > int bnxt_dl_register(struct bnxt *bp)
> > {
> >       struct devlink *dl;
> >@@ -520,40 +552,24 @@ int bnxt_dl_register(struct bnxt *bp)
> >       if (!BNXT_PF(bp))
> >               return 0;
> >
> >-      rc = devlink_params_register(dl, bnxt_dl_params,
> >-                                   ARRAY_SIZE(bnxt_dl_params));
> >-      if (rc) {
> >-              netdev_warn(bp->dev, "devlink_params_register failed. rc=%d",
> >-                          rc);
> >-              goto err_dl_unreg;
> >-      }
> >-
> >       devlink_port_attrs_set(&bp->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
> >                              bp->pf.port_id, false, 0,
> >                              bp->switch_id, sizeof(bp->switch_id));
> >       rc = devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
> >       if (rc) {
> >               netdev_err(bp->dev, "devlink_port_register failed");
> >-              goto err_dl_param_unreg;
> >+              goto err_dl_unreg;
> >       }
> >       devlink_port_type_eth_set(&bp->dl_port, bp->dev);
> >
> >-      rc = devlink_port_params_register(&bp->dl_port, bnxt_dl_port_params,
> >-                                        ARRAY_SIZE(bnxt_dl_port_params));
> >-      if (rc) {
> >-              netdev_err(bp->dev, "devlink_port_params_register failed");
> >+      rc = bnxt_dl_params_register(bp);
> >+      if (rc)
> >               goto err_dl_port_unreg;
> >-      }
> >-
> >-      devlink_params_publish(dl);
> >
> >       return 0;
> >
> > err_dl_port_unreg:
> >       devlink_port_unregister(&bp->dl_port);
> >-err_dl_param_unreg:
> >-      devlink_params_unregister(dl, bnxt_dl_params,
> >-                                ARRAY_SIZE(bnxt_dl_params));
> > err_dl_unreg:
> >       devlink_unregister(dl);
> > err_dl_free:
> >@@ -570,12 +586,8 @@ void bnxt_dl_unregister(struct bnxt *bp)
> >               return;
> >
> >       if (BNXT_PF(bp)) {
> >-              devlink_port_params_unregister(&bp->dl_port,
> >-                                             bnxt_dl_port_params,
> >-                                             ARRAY_SIZE(bnxt_dl_port_params));
> >+              bnxt_dl_params_unregister(bp);
> >               devlink_port_unregister(&bp->dl_port);
> >-              devlink_params_unregister(dl, bnxt_dl_params,
> >-                                        ARRAY_SIZE(bnxt_dl_params));
> >       }
> >       devlink_unregister(dl);
> >       devlink_free(dl);
> >--
> >2.5.1
> >
