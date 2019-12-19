Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B26DD12595D
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 02:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfLSBsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 20:48:17 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43239 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLSBsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 20:48:17 -0500
Received: by mail-pf1-f196.google.com with SMTP id x6so1159279pfo.10
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 17:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z1zgCoxoS355H8oKd/4zPk5NHLvbIh36h9Cq8u5Cno8=;
        b=pDRgVNTfc4oFAnQlNXPZZSY3IEpKlwr0M+X1BAjoZNbP03eeES46HpSXS/pjFoAZ2m
         pcuBupnHYMyoIMAKfuFqJLF852w69kd1ZK1Ie2XjpaGfuZKJPuYbYL2HETHAf2UoHEMj
         lDJY/P17iRmvcdEFzzpd2mXOv2cPFiCkrEq5UmLr+Ebubn86kF3b5PMfGnavGK21ukVX
         Eh1mivquLuhGuZcmyxxmaYTHrw8TJSoDNd6andORoBpajgJxErNlQGwenG4ZhrsUKsHl
         WT/KvUL8BWDCZIkvnY//9UMayE1xXus0zL5/ocPLoegjIN7zaJhc9rmDI25AAQSYYrUr
         8NqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z1zgCoxoS355H8oKd/4zPk5NHLvbIh36h9Cq8u5Cno8=;
        b=U8jbDr0F558+4msXymoWx+qKvU2HURBeVHrHKfgce+XKvNoP9VWfxGkALZR5IlFdUL
         cSnE9vMzyZK9wBHcJMpI0Eu8ZyuQ0A6uwySuqBOd+8VGpkS3L5hnCbVgWylvCdaFz0A1
         dwRfUREMz4vnhTFGG44K+pU9DPoMjalaWSmlk6nvUOVxaxae9b2VZMnbJLD/ReqD0dGK
         sbkW1cUF12h4xvyAgokaTQYrrrU8R7sth56wc5qBWwqGTaDn1q1VVKprYd3L2chqW4CM
         0Tb1Ooc1CIB6K+QPuXm/OM+zyM9nI0b6QihZG6/Fr0RlgivVTF3l0XjfGl//e6LAw3Uw
         PPJA==
X-Gm-Message-State: APjAAAVqiITBJPgKllWQYxctxBL8XK8ZDCKc5EhYoJmldf7Dfu9VyxQa
        mWwMPlwVZ5b5TOSaKdkSo6M=
X-Google-Smtp-Source: APXvYqyJ6I++PJTlmH1d+yh8n9pD9kfBRZX15zW/B7OJERweff2X0kQAXlgqH/eYZcI3VI92UwlmHA==
X-Received: by 2002:a65:5786:: with SMTP id b6mr6410985pgr.316.1576720096267;
        Wed, 18 Dec 2019 17:48:16 -0800 (PST)
Received: from [172.20.20.156] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id z130sm4785268pgz.6.2019.12.18.17.48.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 17:48:15 -0800 (PST)
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
 <20191218081050.10170-12-prashantbhole.linux@gmail.com>
 <20191218110732.33494957@carbon>
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <d34c7552-70b4-72f5-98d2-78db7b5fea41@gmail.com>
Date:   Thu, 19 Dec 2019 10:47:13 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191218110732.33494957@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/18/19 7:07 PM, Jesper Dangaard Brouer wrote:
> On Wed, 18 Dec 2019 17:10:47 +0900
> Prashant Bhole <prashantbhole.linux@gmail.com> wrote:
> 
>> +static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
>> +			 struct xdp_frame *frame)
>> +{
>> +	struct bpf_prog *xdp_prog;
>> +	struct tun_page tpage;
>> +	struct xdp_buff xdp;
>> +	u32 act = XDP_PASS;
>> +	int flush = 0;
>> +
>> +	xdp_prog = rcu_dereference(tun->xdp_tx_prog);
>> +	if (xdp_prog) {
>> +		xdp.data_hard_start = frame->data - frame->headroom;
>> +		xdp.data = frame->data;
>> +		xdp.data_end = xdp.data + frame->len;
>> +		xdp.data_meta = xdp.data - frame->metasize;
> 
> You have not configured xdp.rxq, thus a BPF-prog accessing this will crash.
> 
> For an XDP TX hook, I want us to provide/give BPF-prog access to some
> more information about e.g. the current tx-queue length, or TC-q number.
> 
> Question to Daniel or Alexei, can we do this and still keep BPF_PROG_TYPE_XDP?
> Or is it better to introduce a new BPF prog type (enum bpf_prog_type)
> for XDP TX-hook ?
> 
> To Prashant, look at net/core/filter.c in xdp_convert_ctx_access() on
> how the BPF instruction rewrites are done, when accessing xdp_rxq_info.

Got it. I will take care of it next time.

> 
> 
>> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
>> +		switch (act) {
>> +		case XDP_PASS:
>> +			break;
>> +		case XDP_TX:
>> +			/* fall through */
>> +		case XDP_REDIRECT:
>> +			/* fall through */
>> +		default:
>> +			bpf_warn_invalid_xdp_action(act);
>> +			/* fall through */
>> +		case XDP_ABORTED:
>> +			trace_xdp_exception(tun->dev, xdp_prog, act);
>> +			/* fall through */
>> +		case XDP_DROP:
>> +			xdp_return_frame_rx_napi(frame);
> 
> I'm not sure that it is safe to use "napi" variant here, as you have to
> be under same RX-NAPI processing loop for this to be safe.
> 
> Notice the "rx" part of the name "xdp_return_frame_rx_napi".

You are right, I will fix it next time.

Thanks!

> 
> 
>> +			break;
>> +		}
>> +	}
>> +
>> +	return act;
>> +}
> 
> 
