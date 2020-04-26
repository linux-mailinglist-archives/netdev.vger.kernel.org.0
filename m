Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C361B8E60
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 11:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgDZJk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 05:40:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60342 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726169AbgDZJkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 05:40:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587894054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dszNJQs6fArA/yKsYT4W7GinUXQBUMxovUvmunRNpmo=;
        b=aPPOhfWMoL8fLtj4MJNNmS1Mig9wUm3h7Gho+3HVc4LDiyHdsR8HmU14p2t8BOfDeJ0mxb
        V7IeOGKspqgNtQBTx9SvBnwdszMr5QIlLu/ufO7ENCzp+2SkdBZnMCnyVPg7P0WP+VBBZC
        sJNQxpt9iH9RS1wuX+liG6xoc4nd5t8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-XdL4riJKPg-YZhzKS0PnUQ-1; Sun, 26 Apr 2020 05:40:50 -0400
X-MC-Unique: XdL4riJKPg-YZhzKS0PnUQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0754C107ACCA;
        Sun, 26 Apr 2020 09:40:49 +0000 (UTC)
Received: from [10.72.13.147] (ovpn-13-147.pek2.redhat.com [10.72.13.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAFA560612;
        Sun, 26 Apr 2020 09:40:42 +0000 (UTC)
Subject: Re: [PATCH V3 2/2] vdpa: implement config interrupt in IFCVF
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1587890572-39093-1-git-send-email-lingshan.zhu@intel.com>
 <1587890572-39093-3-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <32fda0dc-b1c7-4a7c-2f97-34a40af45fac@redhat.com>
Date:   Sun, 26 Apr 2020 17:40:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587890572-39093-3-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/26 =E4=B8=8B=E5=8D=884:42, Zhu Lingshan wrote:
> This commit implements config interrupt support
> in IFC VF
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.c |  3 +++
>   drivers/vdpa/ifcvf/ifcvf_base.h |  3 +++
>   drivers/vdpa/ifcvf/ifcvf_main.c | 22 +++++++++++++++++++++-
>   3 files changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf=
_base.c
> index b61b06e..c825d99 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -185,6 +185,9 @@ void ifcvf_set_status(struct ifcvf_hw *hw, u8 statu=
s)
>  =20
>   void ifcvf_reset(struct ifcvf_hw *hw)
>   {
> +	hw->config_cb.callback =3D NULL;
> +	hw->config_cb.private =3D NULL;
> +
>   	ifcvf_set_status(hw, 0);
>   	/* flush set_status, make sure VF is stopped, reset */
>   	ifcvf_get_status(hw);
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf=
_base.h
> index e803070..23ac47d 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -27,6 +27,7 @@
>   		((1ULL << VIRTIO_NET_F_MAC)			| \
>   		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
>   		 (1ULL << VIRTIO_F_VERSION_1)			| \
> +		 (1ULL << VIRTIO_NET_F_STATUS)			| \
>   		 (1ULL << VIRTIO_F_ORDER_PLATFORM)		| \
>   		 (1ULL << VIRTIO_F_IOMMU_PLATFORM)		| \
>   		 (1ULL << VIRTIO_NET_F_MRG_RXBUF))
> @@ -81,6 +82,8 @@ struct ifcvf_hw {
>   	void __iomem *net_cfg;
>   	struct vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
>   	void __iomem * const *base;
> +	char config_msix_name[256];
> +	struct vdpa_callback config_cb;
>   };
>  =20
>   struct ifcvf_adapter {
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf=
_main.c
> index 8d54dc5..f7baeca 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -18,6 +18,16 @@
>   #define DRIVER_AUTHOR   "Intel Corporation"
>   #define IFCVF_DRIVER_NAME       "ifcvf"
>  =20
> +static irqreturn_t ifcvf_config_changed(int irq, void *arg)
> +{
> +	struct ifcvf_hw *vf =3D arg;
> +
> +	if (vf->config_cb.callback)
> +		return vf->config_cb.callback(vf->config_cb.private);
> +
> +	return IRQ_HANDLED;
> +}
> +
>   static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
>   {
>   	struct vring_info *vring =3D arg;
> @@ -256,7 +266,10 @@ static void ifcvf_vdpa_set_config(struct vdpa_devi=
ce *vdpa_dev,
>   static void ifcvf_vdpa_set_config_cb(struct vdpa_device *vdpa_dev,
>   				     struct vdpa_callback *cb)
>   {
> -	/* We don't support config interrupt */
> +	struct ifcvf_hw *vf =3D vdpa_to_vf(vdpa_dev);
> +
> +	vf->config_cb.callback =3D cb->callback;
> +	vf->config_cb.private =3D cb->private;
>   }
>  =20
>   /*
> @@ -292,6 +305,13 @@ static int ifcvf_request_irq(struct ifcvf_adapter =
*adapter)
>   	struct ifcvf_hw *vf =3D &adapter->vf;
>   	int vector, i, ret, irq;
>  =20
> +	snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
> +		pci_name(pdev));
> +	vector =3D 0;
> +	irq =3D pci_irq_vector(pdev, vector);


Nitpick, we can just use pci_irq_vecotr(pdev, 0);

vector will be reassigned soon :)

Thanks


> +	ret =3D devm_request_irq(&pdev->dev, irq,
> +			       ifcvf_config_changed, 0,
> +			       vf->config_msix_name, vf);
>  =20
>   	for (i =3D 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
>   		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",

