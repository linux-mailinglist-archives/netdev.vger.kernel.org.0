Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBE31466C9
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 12:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgAWLeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 06:34:18 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54023 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726026AbgAWLeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 06:34:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579779256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AJ3zLvOWpdbFPYCTblmk8d3fymjfHUJk43gd3GEbQmw=;
        b=DEh9eVyvKxPoOcK9aKYoDyzffY2xuttRnDHUO3B/wGw87h87WAtIHAywtfCyRje42r6iDy
        2NCfuLXyR7AdSVJ1Y23okWKni7YdFZmU/KE4u3WxcsyQd22E5/fsP8712RyMHarexVALTV
        okVxuKaBmF0id4pF8WNk/gaZtiPEV3s=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-GTKfTM8NOh6fmYLakDB6IA-1; Thu, 23 Jan 2020 06:34:15 -0500
X-MC-Unique: GTKfTM8NOh6fmYLakDB6IA-1
Received: by mail-lf1-f69.google.com with SMTP id y73so405465lff.0
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 03:34:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AJ3zLvOWpdbFPYCTblmk8d3fymjfHUJk43gd3GEbQmw=;
        b=AVk90nJwTQU0Uftzu9OD5kREpnWrqDlzmZFFuxBlCSQkqEQEFAhyw23YNjQgJDwarH
         f/H2c6wgCfVJZ9LbJkzF1Wfbo8imz3iiFM6whFsuhZKH500IytpU8zhDoro8X5aGcVNh
         yxv4kal7mYoHkKCb63oLOgSmPaM4RCwcXgQGIKfqUL4I81L7AdWZ9POzZGNqy33PLlS3
         ApkAUWWUa0ppkDOGmKVIruefqhrnvEPGsmjRgwHURP2B1L4qKxhT2+c0ZzfBSxjRyLxX
         psdZBWcez/CVFReFO6cYiYGwHhwgZMWEzACGHaSa+9I5pTjj2ZewqYG87Cdt0r1zLZ43
         I0Ug==
X-Gm-Message-State: APjAAAW/AR2wV+FR9LVHcZuBU6YnxU+Z9XcXuFdGfZRujqwRyYeaYQ6y
        ZJf4hH4nNIxIQdzofpR5ted13xn59d5LrFIECT/jInAiDZmtfeuzFvgwCJVG20fml0g34QfoNAr
        VSoGIOkqZ4nRMn0g5
X-Received: by 2002:ac2:52a5:: with SMTP id r5mr4508750lfm.19.1579779253789;
        Thu, 23 Jan 2020 03:34:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqypUQ3PFLHi2kbaYJ1IOhmkWINdFOc/idMGWcQ1ICzzqoSXbSJI10GfFiHdHeAd9s1TAy8qqg==
X-Received: by 2002:ac2:52a5:: with SMTP id r5mr4508728lfm.19.1579779253597;
        Thu, 23 Jan 2020 03:34:13 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id t10sm1056860lji.61.2020.01.23.03.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 03:34:12 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B56D81800F2; Thu, 23 Jan 2020 12:34:11 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 02/12] net: Add BPF_XDP_EGRESS as a bpf_attach_type
In-Reply-To: <20200123014210.38412-3-dsahern@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org> <20200123014210.38412-3-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 Jan 2020 12:34:11 +0100
Message-ID: <87wo9i9zkc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: Prashant Bhole <prashantbhole.linux@gmail.com>
>
> Add new bpf_attach_type, BPF_XDP_EGRESS, for BPF programs attached
> at the XDP layer, but the egress path.
>
> Since egress path does not have rx_queue_index and ingress_ifindex set,
> update xdp_is_valid_access to block access to these entries in the xdp
> context when a program is attached to egress path.

Isn't the whole point of this to be able to use unchanged XDP programs?
But now you're introducing a semantic difference. Since supposedly only
point-to-point links are going to be using this attach type, don't they
know enough about their peer device to be able to populate those fields
with meaningful values, instead of restricting access to them?

-Toke

