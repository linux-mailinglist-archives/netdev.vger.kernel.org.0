Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFBEEC31F5
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfJALCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 07:02:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbfJALCY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 07:02:24 -0400
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5CDBBC0568FA
        for <netdev@vger.kernel.org>; Tue,  1 Oct 2019 11:02:24 +0000 (UTC)
Received: by mail-lj1-f197.google.com with SMTP id 5so3956614lje.12
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 04:02:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=tNhJPn8uU6pj9bi+Dpgc8PgGbwfOwlu5ne+MdlOuEOk=;
        b=VBz4ot1oZaSq/5mhZxAmu2o3FgnvRTLMMSrC7XNePUA5vjMrAw4OBHgsKvjXgPP+ix
         ewQkJ2cybV9cfuEQtLq5d0neeThQ+SjD7IXaYgLyHJCRqep3Xnw7x1s7X0x0h/OpCfdJ
         AmnikM05iJ6it3i86XcHMPHuhkhsRQLCZ/N32/hMY4UctIINSwVfkZYIN92ezERW9vtq
         qF2yOGY7IWcBytCrJdsZWf3A4IQ4htszPIYORzKVEHDb88smh8ZZFf1kwcJawuhT9I4z
         xAEIP0JH1BtGPKuReiSi4je1zdNhnf1UGy6JjElJJKFl4Z74gRtq5lKG1SUeXd9BAN6R
         DQVA==
X-Gm-Message-State: APjAAAXlTVXFwtveqOOEte1JjAwFUFIv0fCXA9bKFmITTAK0NNYgmm3d
        j0mB6HOv2rVipAloFKUSj/1TrEkRPTm6ZVhjwBx7bgY9mw1uaqiZBWUlMvJBhKP6SFNItlL7wHV
        ShjYrzYT8gQtTka6H
X-Received: by 2002:a2e:9ccb:: with SMTP id g11mr14918633ljj.62.1569927742728;
        Tue, 01 Oct 2019 04:02:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwsAVNG3wo2+3eU0gjtpid7ngv69imM6rB6pzP0RCymMlJWyDawkMn0a6XN518bQPCvWdUNNA==
X-Received: by 2002:a2e:9ccb:: with SMTP id g11mr14918625ljj.62.1569927742531;
        Tue, 01 Oct 2019 04:02:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id 25sm3821163lje.58.2019.10.01.04.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 04:02:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 23CAB18063D; Tue,  1 Oct 2019 13:02:21 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Matteo Croce <mcroce@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [RFC 3/4] net: mvneta: add basic XDP support
In-Reply-To: <20191001123700.5d1fa185@mcroce-redhat>
References: <cover.1569920973.git.lorenzo@kernel.org> <5119bf5e9c33205196cf0e8b6dc7cf0d69a7e6e9.1569920973.git.lorenzo@kernel.org> <20191001123700.5d1fa185@mcroce-redhat>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 01 Oct 2019 13:02:21 +0200
Message-ID: <875zl8vide.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matteo Croce <mcroce@redhat.com> writes:

> On Tue,  1 Oct 2019 11:24:43 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>> +static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog
>> *prog,
>> +			    struct netlink_ext_ack *extack)
>> +{
>> +	struct mvneta_port *pp = netdev_priv(dev);
>> +	struct bpf_prog *old_prog;
>> +
>> +	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not
>> supported on XDP");
>> +		return -EOPNOTSUPP;
>
> -ENOTSUPP maybe?

No, ENOTSUPP is NFS-specific, and defined in a non-UAPI header; the
correct one to use is EOPNOTSUPP :)

-Toke
