Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8716829A551
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 08:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507451AbgJ0HOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 03:14:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44166 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2507447AbgJ0HOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 03:14:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603782893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qoFOH0EIYw+zRVkirbFvitnPatdYcGlTK08xwJlVXUc=;
        b=KxhAsYMRdC6NWkrdJZ7AtIMZ4morPZ8TjG5ubPHqrj7JlfGtmbQKTqgHtjO1WLsrsiEhra
        Y12J4ElAf/Hs4Lug5lNPlfRjAjh+yOb7WOvQsOTqOZo66I0+Xkh4GADjk7rnxUZUA6/Fyl
        8uBXVD7eImk8UQqDy5+E30nifewkE2Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-bWtevY_hNLmjP3o_l2BPDw-1; Tue, 27 Oct 2020 03:14:51 -0400
X-MC-Unique: bWtevY_hNLmjP3o_l2BPDw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A93D1018F61;
        Tue, 27 Oct 2020 07:14:50 +0000 (UTC)
Received: from carbon (unknown [10.36.110.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 023AF5D9E4;
        Tue, 27 Oct 2020 07:14:41 +0000 (UTC)
Date:   Tue, 27 Oct 2020 08:14:40 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     daniel@iogearbox.net, ast@fb.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com,
        Roman Gushchin <guro@fb.com>, kernel-team@fb.com
Subject: Re: [PATCH bpf] samples/bpf: Set rlimit for memlock to infinity in
 all samples
Message-ID: <20201027081440.756cd175@carbon>
In-Reply-To: <20201026233623.91728-1-toke@redhat.com>
References: <20201026233623.91728-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 00:36:23 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> The memlock rlimit is a notorious source of failure for BPF programs. Most
> of the samples just set it to infinity, but a few used a lower limit. The
> problem with unconditionally setting a lower limit is that this will also
> override the limit if the system-wide setting is *higher* than the limit
> being set, which can lead to failures on systems that lock a lot of memor=
y,
> but set 'ulimit -l' to unlimited before running a sample.
>=20
> One fix for this is to only conditionally set the limit if the current
> limit is lower, but it is simpler to just unify all the samples and have
> them all set the limit to infinity.
>=20
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

This change basically disable the memlock rlimit system. And this
disable method is becoming standard in more and more BPF programs.
IMHO using the system-wide memlock rlimit doesn't make sense for BPF.

I'm still ACKing the patch, as this seems the only way forward, to
ignore and in-practice not use the memlock rlimit.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


I saw some patches on the list (from Facebook) with a new system for
policy limiting memory usage per BPF program or was it mem-cgroup, but
I don't think that was ever merged... I would really like to see
something replace (and remove) this memlock rlimit dependency. Anyone
knows what happened to that effort?

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

