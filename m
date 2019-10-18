Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0236DBC95
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504346AbfJRFHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:07:12 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39170 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504332AbfJRFHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:07:11 -0400
Received: by mail-pf1-f194.google.com with SMTP id v4so3087555pff.6;
        Thu, 17 Oct 2019 22:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Dxf8j2dEp3gTKMidNHZOyi9cs38t6awcBjwDt5BGhco=;
        b=kRzCl2sU8HhkN2FXU+AB6DHrD5pGZGK8OzQmjA2iRV6j8bod6JDJwCXwZC8OqJep3i
         QNOn6QPM8Bq+xIddUidzOPgmu00nR5ZPwUV7rrfcXd2kzv461ggEh4UgeDVYvC0n30Pq
         RaU1oHJXZyKXREXUNgwJr6IkVla6HHwlvRVaZ5SDQcJwXNjhLA+evDK9MEmFovwM5Bfc
         HLqGNtPyecQjdt66rCHEz+h+1dr028s9/pFc3Fs65iCHDm/IGdPVpX9sDB1W1FIRzrJ5
         YFC3yFRe0G0Fs+luyOzFip9poCXoUo8sJAN3HXEZu9QoPJzGJGsHl5eIUCZctGMuOeEf
         2oYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Dxf8j2dEp3gTKMidNHZOyi9cs38t6awcBjwDt5BGhco=;
        b=TsIvVYg91c/j+hQqMVQl4rYoTHUFIeBsflKovafgcj3B6NuEavA16Nm5cF24DgaqOB
         GRth1ERyBWnVKh0XYxwrknC1KmTJjHkKlt14EXi3NyQ2eL5SYecl5vJH184m4OuEFwjy
         j0P4gBakmm/0P7SBAC71cXriHY42LMBMCJ6AJV1vAvO/yRBQf5Lyi+OD2J9oeKaXU54a
         qVXv4JuQ1xf2yq65l0c3F0hiRzx+WK7H2SLoECR3HodwdOz9pc+qdTX5nSRDnquPX+iO
         0uVBMEmxZFUQlrwZJ4LIdjjL9JfCWIrbX5+UQJJzjs9LrQFKDQfNe9hr8vYfhpzln8Ls
         bz/g==
X-Gm-Message-State: APjAAAXaDKri+4RYM7bSIqLjMV5kgU/pOGW74unq1CW7XArix2nvHjEs
        QC64My3a+I+aJE6iLafOoWxO9L/I
X-Google-Smtp-Source: APXvYqx7/HwYNBy93h+fmNaI9cnTLMGY7XFYbErDicOBeRlQ0eTPm/1tR+ecZKuvPeC4oiDJ4HVdmw==
X-Received: by 2002:a17:90a:9201:: with SMTP id m1mr8641712pjo.74.1571371532978;
        Thu, 17 Oct 2019 21:05:32 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m2sm6433577pff.154.2019.10.17.21.05.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Oct 2019 21:05:31 -0700 (PDT)
Date:   Thu, 17 Oct 2019 21:05:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Hui Peng <benquike@gmail.com>, davem@davemloft.net,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix a NULL-ptr-deref bug in
 ath10k_usb_alloc_urb_from_pipe
Message-ID: <20191018040530.GA28167@roeck-us.net>
References: <20190804003101.11541-1-benquike@gmail.com>
 <20190831213139.GA32507@roeck-us.net>
 <87ftlgqw42.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ftlgqw42.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 01, 2019 at 11:06:05AM +0300, Kalle Valo wrote:
> Guenter Roeck <linux@roeck-us.net> writes:
> 
> > Hi,
> >
> > On Sat, Aug 03, 2019 at 08:31:01PM -0400, Hui Peng wrote:
> >> The `ar_usb` field of `ath10k_usb_pipe_usb_pipe` objects
> >> are initialized to point to the containing `ath10k_usb` object
> >> according to endpoint descriptors read from the device side, as shown
> >> below in `ath10k_usb_setup_pipe_resources`:
> >> 
> >> for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
> >>         endpoint = &iface_desc->endpoint[i].desc;
> >> 
> >>         // get the address from endpoint descriptor
> >>         pipe_num = ath10k_usb_get_logical_pipe_num(ar_usb,
> >>                                                 endpoint->bEndpointAddress,
> >>                                                 &urbcount);
> >>         ......
> >>         // select the pipe object
> >>         pipe = &ar_usb->pipes[pipe_num];
> >> 
> >>         // initialize the ar_usb field
> >>         pipe->ar_usb = ar_usb;
> >> }
> >> 
> >> The driver assumes that the addresses reported in endpoint
> >> descriptors from device side  to be complete. If a device is
> >> malicious and does not report complete addresses, it may trigger
> >> NULL-ptr-deref `ath10k_usb_alloc_urb_from_pipe` and
> >> `ath10k_usb_free_urb_to_pipe`.
> >> 
> >> This patch fixes the bug by preventing potential NULL-ptr-deref.
> >> 
> >> Signed-off-by: Hui Peng <benquike@gmail.com>
> >> Reported-by: Hui Peng <benquike@gmail.com>
> >> Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
> >
> > This patch fixes CVE-2019-15099, which has CVSS scores of 7.5 (CVSS 3.0)
> > and 7.8 (CVSS 2.0). Yet, I don't find it in the upstream kernel or in Linux
> > next.
> >
> > Is the patch going to be applied to the upstream kernel anytime soon ?
> 
> Same answer as in patch 1:
> 
> https://patchwork.kernel.org/patch/11074655/
> 

Sorry to bring this up again. The ath6k patch made it into the upstream
kernel, but the ath10k patch didn't. Did it get lost, or was there a
reason not to apply this patch ?

Thanks,
Guenter
