Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB450F588C
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbfKHUeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:34:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23110 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726121AbfKHUeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 15:34:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573245263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1J9XRzgv8tEisFHwe6ZLIm1lh2lFwvSIiZ8VW7cA8fo=;
        b=ZrK9dptgNtCUYXnr15QYIBwnSPD8jxhu6k0ekcxYU+YyuOR7/n8+ncbHOsvudRSF0KH04y
        JNaKffbM56nY0uh/fgm2ay3+plXLh2Z3+AlHWMGtj5mn081cV8IrqqP/xTyzTGxP0AzfNi
        ZwW2sPUYy+cnSepA6DPv5BUCIHJqNx4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-hbE6sfLtM5K60PiLfdKpRQ-1; Fri, 08 Nov 2019 15:34:19 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 581E8800C72;
        Fri,  8 Nov 2019 20:34:18 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FDD95D6AE;
        Fri,  8 Nov 2019 20:34:15 +0000 (UTC)
Date:   Fri, 08 Nov 2019 12:34:14 -0800 (PST)
Message-Id: <20191108.123414.449750781962812415.davem@redhat.com>
To:     anthony.l.nguyen@intel.com
Cc:     jeffrey.t.kirsher@intel.com, nhorman@redhat.com,
        netdev@vger.kernel.org, anirudh.venkataramanan@intel.com,
        sassmann@redhat.com, andrewx.bowers@intel.com
Subject: Re: [net-next 01/15] ice: Use ice_ena_vsi and ice_dis_vsi in DCB
 configuration flow
From:   David Miller <davem@redhat.com>
In-Reply-To: <54c22ba9110b299f9f222cd1cffbdfb6ca6024d8.camel@intel.com>
References: <20191107221438.17994-2-jeffrey.t.kirsher@intel.com>
        <20191107.162550.125702977926999669.davem@davemloft.net>
        <54c22ba9110b299f9f222cd1cffbdfb6ca6024d8.camel@intel.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: hbE6sfLtM5K60PiLfdKpRQ-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Date: Fri, 8 Nov 2019 18:08:41 +0000

> On Thu, 2019-11-07 at 16:25 -0800, David Miller wrote:
>> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> Date: Thu,  7 Nov 2019 14:14:24 -0800
>>=20
>> > @@ -169,15 +170,23 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct
>> > ice_dcbx_cfg *new_cfg, bool locked)
>> >  =09}
>> > =20
>> >  =09/* Store old config in case FW config fails */
>> > -=09old_cfg =3D devm_kzalloc(&pf->pdev->dev, sizeof(*old_cfg),
>> > GFP_KERNEL);
>> > -=09memcpy(old_cfg, curr_cfg, sizeof(*old_cfg));
>> > +=09old_cfg =3D kmemdup(curr_cfg, sizeof(*old_cfg), GFP_KERNEL);
>>=20
>> Why not use devm_kmemdup()?  Then you don't have to add the kfree()
>> code paths.
>=20
>=20
> https://lore.kernel.org/netdev/20190819161142.6f4cc14d@cakuba.netronome.c=
om/
>=20
> https://lore.kernel.org/netdev/20190819.165955.1428577625599018007.davem@=
davemloft.net/
>=20
> https://lore.kernel.org/netdev/20190819.183158.1151163538921922149.davem@=
davemloft.net/
>=20
> Our interpretation of this feedback was that it is unnecessary to use
> devres variants of memory allocation/deallocation when memory is
> alloc'd and freed in the same function. After getting this feedback, we
> are changing the ice driver to follow this guideline and this change is
> one of those.

Ok.

