Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E74716F653
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 05:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgBZECi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 23:02:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40802 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726024AbgBZECi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 23:02:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582689757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=umEhPCQC0tojIB9fDR4tkHN0aAI9X1bB8BVWQ54hLrs=;
        b=FvSrJGZHoWtZtQUR1ZF4LBfMqxNPo4BHRmy37CuaqL6srNEXOYuNmrhhznYKk6eJ8DelJO
        UfdzSJZt37V9yIid2U9p0Zn7eef4IHADAGtgwAlreQknjNl6MuReTWExfJxuvNEqTGCK8o
        kTvl+T03kL0UBwoB5wqQfJxzZI3ePfo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-54JQT3CEMlqD2f5puQSQqg-1; Tue, 25 Feb 2020 23:02:33 -0500
X-MC-Unique: 54JQT3CEMlqD2f5puQSQqg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 907F2801E74;
        Wed, 26 Feb 2020 04:02:32 +0000 (UTC)
Received: from [10.72.13.217] (ovpn-13-217.pek2.redhat.com [10.72.13.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1FB5100164D;
        Wed, 26 Feb 2020 04:02:15 +0000 (UTC)
Subject: Re: virtio_net: can change MTU after installing program
To:     David Ahern <dahern@digitalocean.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <07bb0ad3-c3e9-4a23-6e75-c3df6a557dcf@redhat.com>
Date:   Wed, 26 Feb 2020 12:02:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/26 =E4=B8=8A=E5=8D=8811:32, David Ahern wrote:
> Another issue is that virtio_net checks the MTU when a program is
> installed, but does not restrict an MTU change after:
>
> # ip li sh dev eth0
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc fq_codel
> state UP mode DEFAULT group default qlen 1000
>      link/ether 5a:39:e6:01:a5:36 brd ff:ff:ff:ff:ff:ff
>      prog/xdp id 13 tag c5595e4590d58063 jited
>
> # ip li set dev eth0 mtu 8192
>
> # ip li sh dev eth0
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8192 xdp qdisc fq_codel
> state UP mode DEFAULT group default qlen 1000
>
>
> The simple solution is:
>
> @@ -2489,6 +2495,8 @@ static int virtnet_xdp_set(struct net_device *dev=
,
> struct bpf_prog *prog,
>                  }
>          }
>
> +       dev->max_mtu =3D prog ? max_sz : MAX_MTU;
> +
>          return 0;
>
>   err:
>
> The complicated solution is to implement ndo_change_mtu.


Right, this issue has been there for years. Qemu (or libvirt) should=20
configure TAP MTU accordingly. But there's no way for driver to tell=20
device about the MTU it wants to use. We need fix this.


>
> The simple solution causes a user visible change with 'ip -d li sh' by
> showing a changing max mtu, but the ndo has a poor user experience in
> that it just fails EINVAL (their is no extack) which is confusing since=
,
> for example, 8192 is a totally legit MTU. Changing the max does return =
a
> nice extack message.


Or for simplicity, just forbid changing MTU when program is installed?

Thanks


>

