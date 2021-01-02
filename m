Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DC12E8943
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 00:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbhABXIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 18:08:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39275 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726785AbhABXIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 18:08:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609628823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=haYPUQnlq92kVGfzi+gKYWueiXZI9wZI1FGZmjza/5k=;
        b=Tk2SzJujbPEutOUBqGOrOyoAXO3kywKTtqg6X8glUnIHh7Gocn0Zm8dS3YeZxB/0X9qs/U
        0GP9JnjlOI247g9ktrwN5YeQD8SA16jem/Nkg7ceqLX1KOyKCYaUpjZ3dVs5+AkdhI9kHW
        /476RsARR+w61WjtuBiKushVKsv9jlk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-pVONn62IOSqtFEkvCq5I3w-1; Sat, 02 Jan 2021 18:07:00 -0500
X-MC-Unique: pVONn62IOSqtFEkvCq5I3w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB604C287;
        Sat,  2 Jan 2021 23:06:57 +0000 (UTC)
Received: from krava (unknown [10.40.192.22])
        by smtp.corp.redhat.com (Postfix) with SMTP id 3EE75100239A;
        Sat,  2 Jan 2021 23:06:55 +0000 (UTC)
Date:   Sun, 3 Jan 2021 00:06:54 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Qais Yousef <qais.yousef@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: BTFIDS: FAILED unresolved symbol udp6_sock
Message-ID: <20210102230654.GA732432@krava>
References: <20201229151352.6hzmjvu3qh6p2qgg@e107158-lin>
 <20201229173401.GH450923@krava>
 <20201229232835.cbyfmja3bu3lx7we@e107158-lin>
 <20201230090333.GA577428@krava>
 <20201230132759.GB577428@krava>
 <CAEf4BzYbeQqzK2n9oz6wqysVj35k+VZC7DZrXFEtjUM6eiyvOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYbeQqzK2n9oz6wqysVj35k+VZC7DZrXFEtjUM6eiyvOA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 02, 2021 at 02:25:34PM -0800, Andrii Nakryiko wrote:

SNIP

> >
> > so your .config has
> >   CONFIG_CRYPTO_DEV_BCM_SPU=y
> >
> > and that defines 'struct device_private' which
> > clashes with the same struct defined in drivers/base/base.h
> >
> > so several networking structs will be doubled, like net_device:
> >
> >         $ bpftool btf dump file ../vmlinux.config | grep net_device\' | grep STRUCT
> >         [2731] STRUCT 'net_device' size=2240 vlen=133
> >         [113981] STRUCT 'net_device' size=2240 vlen=133
> >
> > each is using different 'struct device_private' when it's unwinded
> >
> > and that will confuse BTFIDS logic, becase we have multiple structs
> > with the same name, and we can't be sure which one to pick
> >
> > perhaps we should check on this in pahole and warn earlier with
> > better error message.. I'll check, but I'm not sure if pahole can
> > survive another hastab ;-)
> >
> > Andrii, any ideas on this? ;-)
> 
> It's both unavoidable and correct from the C type system's
> perspective, so there is nothing for pahole to warn about. We used to
> have (for a long time) a similar clash with two completely different
> ring_buffer structs. Eventually they just got renamed to avoid
> duplication of related structs (task_struct and tons of other). But
> both BTF dedup and CO-RE relocation algorithms are designed to handle
> this correctly, ...

AFAIU it's all correctly dedulicated, but still all structs that
contain (at some point) 'struct device_private' will appear twice
in BTF data.. each with different 'struct device_private'

> ... so perhaps BTFIDS should be able to handle this as
> well?

hm, BTFIDS sees BTF data with two same struct names and has no
way to tell which one to use

unless we have some annotation data for BTF types I don't
see a way to handle this correctly.. but I think we can
detect this directly in BTFIDS and print more accurate error
message

as long as we dont see this on daily basis, I think that better
error message + following struct rename is good solution

> 
> >
> > easy fix is the patch below that renames the bcm's structs,
> > it makes the kernel to compile.. but of course the new name
> > is probably wrong and we should push this through that code
> > authors
> 
> In this case, I think renaming generic device_private name is a good
> thing regardless.

ok, I'll send the change

jirka

