Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29A4F883C
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 06:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfKLFu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 00:50:59 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47363 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725881AbfKLFu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 00:50:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573537857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=okQw7B6ttHkOXCh+ySF/sHsO0zOkI33D5WOZ3oZ0w7U=;
        b=NsDKEfewAaPFbQU1ddl1QOTOLCKvPG0GaCV9AGBCNnf58wQ+JN6DbrqvKoR3A5pAIGbYIM
        tJGv/VQ57HJTdxIyfaucBoj6rTU0K1f271VJT0n1Xr7QBmhkq+ejFXvfw+8A5UeeDrkjjA
        COCExRVYRexrAmMeIKVbax3RBLmRGII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-ek_CHtHyN5uiV7QJTlY1Pg-1; Tue, 12 Nov 2019 00:50:53 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E06A1005500;
        Tue, 12 Nov 2019 05:50:52 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F24F761071;
        Tue, 12 Nov 2019 05:50:48 +0000 (UTC)
Date:   Mon, 11 Nov 2019 21:50:47 -0800 (PST)
Message-Id: <20191111.215047.316217567209805516.davem@redhat.com>
To:     po.liu@nxp.com
Cc:     claudiu.manoil@nxp.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vinicius.gomes@intel.com,
        vladimir.oltean@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, roy.zang@nxp.com, mingkai.hu@nxp.com,
        jerry.huang@nxp.com, leoyang.li@nxp.com
Subject: Re: [net-next, 1/2] enetc: Configure the Time-Aware Scheduler via
 tc-taprio offload
From:   David Miller <davem@redhat.com>
In-Reply-To: <20191111042715.13444-1-Po.Liu@nxp.com>
References: <20191111042715.13444-1-Po.Liu@nxp.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: ek_CHtHyN5uiV7QJTlY1Pg-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po Liu <po.liu@nxp.com>
Date: Mon, 11 Nov 2019 04:41:26 +0000

> +fsl-enetc-$(CONFIG_NET_SCH_TAPRIO) +=3D enetc_qos.o

Code is Kconfig guarded.
> +=09case TC_SETUP_QDISC_TAPRIO:
> +=09=09return enetc_setup_tc_taprio(ndev, type_data);

Yet invoked unconditionally.

I can see just by reading your code that various configurations will
result in link errors.

 ...
> +int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
> +{
> +=09struct tc_taprio_qopt_offload *taprio =3D type_data;
> +=09struct enetc_ndev_priv *priv =3D netdev_priv(ndev);
> +=09int i;
> +
> +=09for (i =3D 0; i < priv->num_tx_rings; i++)
> +=09=09enetc_set_bdr_prio(&priv->si->hw,
> +=09=09=09=09   priv->tx_ring[i]->index,
> +=09=09=09=09   taprio->enable ? i : 0);
> +
> +=09return enetc_setup_taprio(ndev, taprio);
> +}
> --=20
> 2.17.1
>=20

