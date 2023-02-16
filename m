Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1CDF698F65
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 10:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjBPJLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 04:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjBPJLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 04:11:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1731D5FF0
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 01:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676538655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LM/k6QEKCDHsmvPp7/LX9C3KUoNmJ3MdfN4YDZpArYY=;
        b=RQpeg3ZfhLAxN9pH7yc0I/nZHxX2pbqLMoDPNfsNk+lcH+MpYW5EV0zm5fR99eAKnGaRAa
        5NXy1AEJczz11NJ6WgvrQ3c5qu83tvAmGzKeI8ivGUgCovxeTp6eDzTmM9wYsbFlwMzsrc
        m5EdStgAl9nje9flpaol+tF39myVm94=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-647-CgWnthRLNwOOk17Pyh-snw-1; Thu, 16 Feb 2023 04:10:53 -0500
X-MC-Unique: CgWnthRLNwOOk17Pyh-snw-1
Received: by mail-qt1-f197.google.com with SMTP id cd3-20020a05622a418300b003b9bd2a2284so885026qtb.4
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 01:10:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LM/k6QEKCDHsmvPp7/LX9C3KUoNmJ3MdfN4YDZpArYY=;
        b=LqAo0G14p6R+V/Fs1zDCodo7MaSUKMDYdWwU8tPP6DK0/u9wMbsFKMeMZbgbjXjR5q
         kJXGfGckEiTiL96LhJuJPTQu5sEkNXZ82ansLaPbcfx6bNEfciP+M0Jl3Ltw/TsLzg15
         816x7NMnoiMXljsKeV+4l5IgFiEIPvhzq5BCfLbQc97b0DGg/mXoQGCfVj0gPZOm+8Yx
         1ueGRqoP33/4VGLsu5HQmKFZco/BhxCFNxCicvh1ZbhdKu2FczSEngwKh2i4gIKv4/U+
         ztI2IQUZ/Znj2USYH+qXbSXnV01ov5KouW2qA7lQsG7QOqj8RCzAXrkA0YZSzCqPqjYs
         02GQ==
X-Gm-Message-State: AO0yUKUFXHYNnqnz7CQrc0x4cBogzJQnWhjjb0JTih6TfWvbj04qOTtG
        rFcp2IlG/jop7dz49FbCF0nUWyz7Zp9LmsleAOWDm0vOyi7sz17iI2sMbbDc3ke/HozoENhwk/O
        ZmUniItbrmGiwnjBm
X-Received: by 2002:a0c:f393:0:b0:56c:d9e:c9a0 with SMTP id i19-20020a0cf393000000b0056c0d9ec9a0mr7657751qvk.1.1676538653323;
        Thu, 16 Feb 2023 01:10:53 -0800 (PST)
X-Google-Smtp-Source: AK7set962i1JkfbW/P3g1lxZO0XxXk9C3rsZX/Vc2olLm/AU5K0fr5wQWdCFipxEatsAOteEJSMo6g==
X-Received: by 2002:a0c:f393:0:b0:56c:d9e:c9a0 with SMTP id i19-20020a0cf393000000b0056c0d9ec9a0mr7657730qvk.1.1676538653028;
        Thu, 16 Feb 2023 01:10:53 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id p187-20020a378dc4000000b0073b6c46f048sm801227qkd.68.2023.02.16.01.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 01:10:52 -0800 (PST)
Message-ID: <89c60b9f14e3450f14a5337e8dfd6c3972c7be22.camel@redhat.com>
Subject: Re: [PATCH net-next v1 2/2] net/core: refactor promiscuous mode
 message
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>, kuba@kernel.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        edumazet@google.com
Date:   Thu, 16 Feb 2023 10:10:50 +0100
In-Reply-To: <20230214210117.23123-3-jesse.brandeburg@intel.com>
References: <20230214210117.23123-1-jesse.brandeburg@intel.com>
         <20230214210117.23123-3-jesse.brandeburg@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
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

On Tue, 2023-02-14 at 13:01 -0800, Jesse Brandeburg wrote:
> The kernel stack can be more consistent by printing the IFF_PROMISC
> aka promiscuous enable/disable messages with the standard netdev_info
> message which can include bus and driver info as well as the device.
>=20
> typical command usage from user space looks like:
> ip link set eth0 promisc <on|off>
>=20
> But lots of utilities such as bridge, tcpdump, etc put the interface into
> promiscuous mode.
>=20
> old message:
> [  406.034418] device eth0 entered promiscuous mode
> [  408.424703] device eth0 left promiscuous mode
>=20
> new message:
> [  406.034431] ice 0000:17:00.0 eth0: entered promiscuous mode
> [  408.424715] ice 0000:17:00.0 eth0: left promiscuous mode
>=20
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
> I'm unsure about this one because it's changing a long standard kernel
> message to a slightly different format. I think the new way looks better
> and has more information.

I guess the relevant question here is if such kind of messages are
somewhat implicitly part of uAPI.

AFAIK the answer is "no", at least for info-level msg, so the patch
LGTM.

Thanks,

Paolo


