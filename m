Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C5069DB9E
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 09:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbjBUICS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 03:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbjBUICQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 03:02:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EADC16AC8
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 00:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676966490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=20m9O9S935OXurO2qATakjHtcSQgyRGzklNBw5/tXJQ=;
        b=KtBTjFgsPAcsWZsc8zN9eZyeuv4l7807vekt4fn8VqIt7Cdy0lFEC+PjxuEztFOfb8vlot
        xOyTeGxRMQon0ccPYaTLxz7Wb+m6UvsNXlSgDgnYk8P7txha5eA2d/V/DY2gSgvDXQh74r
        xxGebTvCsADyU1fhQ74WqjWEwAEvzRI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-82-OgmaoducPY-CL7f1qxLBew-1; Tue, 21 Feb 2023 03:01:28 -0500
X-MC-Unique: OgmaoducPY-CL7f1qxLBew-1
Received: by mail-wm1-f71.google.com with SMTP id t1-20020a7bc3c1000000b003dfe223de49so1757293wmj.5
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 00:01:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676966487;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=20m9O9S935OXurO2qATakjHtcSQgyRGzklNBw5/tXJQ=;
        b=w56sWZFG5YzT2dVOsA5fn+pdNPyupt1zfyEB87iMH4pXgeo8AJgivZm2NgSl+kepGm
         iOdVBHIz3BJ9O+ydbmFiXdLZT00eylhKxQ0p/xJGrm7SX0gDHtsCm5Z2NMe1Jgx56Mjt
         gy0lYD/J1RkNEwJZwu8/gH3P/w51Byn27mXb0LvGkkmOu1OXyaLPlZA+mbju/dn0z0yl
         52y9uV12E3UPSD/E/0L/Cl4vbWuEsxDmLPYdmD4ERmVCda8D4+sRIW0ThOqzMA76letk
         jmyeItqaDvb4axdwSUT6MVOI8HkUCcobz/zTeKaUC1PEAm7Xw2JL/RcwD4VNwOEwImDr
         916g==
X-Gm-Message-State: AO0yUKXIfRMJdBup5fxqYe2DXS1Fz1Tmd0fswT/BM9PVPvRlAL7i8vWB
        qhsGqImDQAqP4v/lORhReaCPT6gY7LuYHEslLLdHBW0Af7Kv5IpBWrFa3n/MJ9cXOeH8NvB0x1j
        9A4k9dKIkFp/RQ+Qm
X-Received: by 2002:a05:600c:a05:b0:3dc:3b1a:5d2d with SMTP id z5-20020a05600c0a0500b003dc3b1a5d2dmr3447683wmp.0.1676966487531;
        Tue, 21 Feb 2023 00:01:27 -0800 (PST)
X-Google-Smtp-Source: AK7set+d8BkkknfvE1kWSeXLnDiDryM/K0/dpHAcEiLlRRMcgi2qSCb8KXSRJ0F4bHenQXyCTAd4yQ==
X-Received: by 2002:a05:600c:a05:b0:3dc:3b1a:5d2d with SMTP id z5-20020a05600c0a0500b003dc3b1a5d2dmr3447629wmp.0.1676966486898;
        Tue, 21 Feb 2023 00:01:26 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id az35-20020a05600c602300b003daf672a616sm958872wmb.22.2023.02.21.00.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 00:01:26 -0800 (PST)
Message-ID: <7dcc62b6536be05c784a50bf8a6da89eb3003697.camel@redhat.com>
Subject: Re: [PATCH net-next v3 1/1] ice: Change assigning method of the CPU
 affinity masks
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pawel Chmielewski <pawel.chmielewski@intel.com>,
        netdev@vger.kernel.org
Cc:     intel-wired-lan@osuosl.org
Date:   Tue, 21 Feb 2023 09:01:25 +0100
In-Reply-To: <20230217220359.987004-1-pawel.chmielewski@intel.com>
References: <20230217220359.987004-1-pawel.chmielewski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-02-17 at 23:03 +0100, Pawel Chmielewski wrote:
> With the introduction of sched_numa_hop_mask() and for_each_numa_hop_mask=
(),
> the affinity masks for queue vectors can be conveniently set by preferrin=
g the
> CPUs that are closest to the NUMA node of the parent PCI device.
>=20
> Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
> ---
> Changes since v2:
>  * Pointers for cpumasks point to const struct cpumask
>  * Removed unnecessary label
>  * Removed redundant blank lines
>=20
> Changes since v1:
>  * Removed obsolete comment
>  * Inverted condition for loop escape
>  * Incrementing v_idx only in case of available cpu
> ---
>  drivers/net/ethernet/intel/ice/ice_base.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethe=
rnet/intel/ice/ice_base.c
> index 1911d644dfa8..30dc1c3c290f 100644
> --- a/drivers/net/ethernet/intel/ice/ice_base.c
> +++ b/drivers/net/ethernet/intel/ice/ice_base.c
> @@ -121,9 +121,6 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi=
, u16 v_idx)
> =20
>  	if (vsi->type =3D=3D ICE_VSI_VF)
>  		goto out;
> -	/* only set affinity_mask if the CPU is online */
> -	if (cpu_online(v_idx))
> -		cpumask_set_cpu(v_idx, &q_vector->affinity_mask);
> =20
>  	/* This will not be called in the driver load path because the netdev
>  	 * will not be created yet. All other cases with register the NAPI
> @@ -662,8 +659,10 @@ int ice_vsi_wait_one_rx_ring(struct ice_vsi *vsi, bo=
ol ena, u16 rxq_idx)
>   */
>  int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi)
>  {
> +	const struct cpumask *aff_mask, *last_aff_mask =3D cpu_none_mask;
>  	struct device *dev =3D ice_pf_to_dev(vsi->back);
> -	u16 v_idx;
> +	int numa_node =3D dev->numa_node;

The above breaks the build when CONFIG_XPS and CONFIG_NUMA are not
defined.

Note: net-next is now closed, please post the new revision after the
merge window, when net-next will re-open.

Thank,

Paolo

