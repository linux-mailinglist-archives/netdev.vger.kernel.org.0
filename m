Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3D117B956
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 10:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgCFJdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 04:33:36 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39019 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgCFJdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 04:33:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583487214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5twIfR2LvQIEiEzP80/5MmktjTFqoWR3J055Yx+mRa8=;
        b=h4bX50Kul3e6GEvn64ImD2/kbiSECJ2VUz1bjAYdR5xc/qbaAWxRlTQ3+g//fU75VLCd1d
        Pj3+DXeaTUlXXFUTHRcnTUgoFSIz3qGO1YqH/1MheZKC/Q6tnGEQbjljbr+Wh7NV7uHcA9
        Y0dmpb6eaSSYL3LXyN5MNutxCCDDS+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-OGC8puxlNeSTcYwNhDEwGQ-1; Fri, 06 Mar 2020 04:33:31 -0500
X-MC-Unique: OGC8puxlNeSTcYwNhDEwGQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7895A13FF;
        Fri,  6 Mar 2020 09:33:27 +0000 (UTC)
Received: from [10.72.13.58] (ovpn-13-58.pek2.redhat.com [10.72.13.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D0B510016EB;
        Fri,  6 Mar 2020 09:33:18 +0000 (UTC)
Subject: Re: [PATCH net-next 3/7] tun: reject unsupported coalescing params
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        linux-um@lists.infradead.org, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, linux-rdma@vger.kernel.org, edumazet@google.com,
        mkubecek@suse.cz, hayeswang@realtek.com, doshir@vmware.com,
        pv-drivers@vmware.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, gregkh@linuxfoundation.org,
        merez@codeaurora.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20200306010602.1620354-1-kuba@kernel.org>
 <20200306010602.1620354-4-kuba@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <36c409f7-a8b4-50f6-4933-1c8105755d11@redhat.com>
Date:   Fri, 6 Mar 2020 17:33:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200306010602.1620354-4-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/3/6 =E4=B8=8A=E5=8D=889:05, Jakub Kicinski wrote:
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
>
> This driver did not previously reject unsupported parameters.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   drivers/net/tun.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 79f248cb282d..9e8f23519e82 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -3597,6 +3597,7 @@ static int tun_set_coalesce(struct net_device *de=
v,
>   }
>  =20
>   static const struct ethtool_ops tun_ethtool_ops =3D {
> +	.supported_coalesce_params =3D ETHTOOL_COALESCE_RX_MAX_FRAMES,
>   	.get_drvinfo	=3D tun_get_drvinfo,
>   	.get_msglevel	=3D tun_get_msglevel,
>   	.set_msglevel	=3D tun_set_msglevel,


Acked-by: Jason Wang <jasowang@redhat.com>



