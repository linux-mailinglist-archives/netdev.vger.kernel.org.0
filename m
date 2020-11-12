Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614692B0E1A
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgKLTbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:31:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:38468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbgKLTbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 14:31:31 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3C5F20715;
        Thu, 12 Nov 2020 19:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605209491;
        bh=vet3JZADgbsjevw1yBYk/Yjxca1RCd3PQILGLiZ9zNw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p3MU9qv4Y+5Mz353kLVybbuz4z0h869QPJ7ND8r2uUkvDFyOhRz3kXbtgrqNkWkr7
         nmg9kYi0fW7OCpuYR/P0U+JFmr+FI2uBWerPX/Lrfn/rOsIYq83LpQJXRFk9OxcRDC
         kA7P0HUfaCCwTFQBPf93ruqi/ajCnabdNK2F4EkQ=
Message-ID: <14da7d0820e3e185dcb65e010d16c818ad030e33.camel@kernel.org>
Subject: Re: Hardware time stamping support for AF_XDP applications
From:   Saeed Mahameed <saeed@kernel.org>
To:     "Patel, Vedang" <vedang.patel@intel.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Guedes, Andre" <andre.guedes@intel.com>
Date:   Thu, 12 Nov 2020 11:31:28 -0800
In-Reply-To: <65418F25-1795-4FF7-AB04-8DE78F0C8BF5@intel.com>
References: <7299CEB5-9777-4FE4-8DEE-32EF61F6DA29@intel.com>
         <6af7754d5bcba7a7f7d92dc43e1f4206ce470c79.camel@kernel.org>
         <65418F25-1795-4FF7-AB04-8DE78F0C8BF5@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-10 at 23:53 +0000, Patel, Vedang wrote:
> > With BTF formatted metadata it is up to the driver to advertise
> > whatever it can/want :)
> > so yes.
> 
> I have a very basic question here. From what I understand about BTF,
> I can generate a header file (using bpftool?) containing the BTF data
> format provided by the driver. If so, how can I design an application
> which can work with multiple NICs drivers without recompilation? I am
> guessing there is some sort of “master list” of HW hints the drivers
> will agree upon?

Hi Patel, as Jesper mentioned, some hints will be well defined in BTF
format, by name, size and type, e.g.:

   u32 hash32;
   u16 vlan_tci;
   u64 timestamp;

etc.. 

if the driver reports only well known hints, a program compiled with
these can work in theory on any NIC that supports them. the BPF program
loader/verifier in the kernel can check compatibility before loading a
program on a NIC.

now the question remains, What if different NICs/Drivers re-arrange
those fields differently? 
this also can be solved by the BPF XDP program loader in the kernel at
rung time, it can re-arrange the meta data offsets according to the
current NIC directly in the byte code, but this is going to be a future
work.

