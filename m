Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C452DAB629
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 12:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbfIFKk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 06:40:29 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40182 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728269AbfIFKk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 06:40:29 -0400
Received: by mail-lj1-f194.google.com with SMTP id 7so5527339ljw.7;
        Fri, 06 Sep 2019 03:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DnJ87hIg+L1soXqzK+F25qs93DUI2WPEksuGAxLMiCg=;
        b=mharq59n+r5qjSdEntYwXvnT+ExtPjvbWik0d4+O74MQf1tqAh5eJeAjWA1uEadW0F
         HdmodOWAFbFf+iwZonCqgrY8IL/8bDX4HFJwwrIGI8n9iQBrBEmfSc07WrFgAPTrFx5P
         UqJbOXZVrmOjsJ9Bf70sOnFq2U1dBFxDtknIR1tmHddw+AkeYRDXoDgzPGmi81XmZ6Qp
         u8aO9ADtOB+EbeSx1YErPF6mNU16YZ12CV+cQHmXhd8yVFhSoQglDClbm0hxWEB+1xd9
         6wjHjq0Lln6XleGgxxqOJ/+ZYJ9YfmwlJTn1ldBEVW1b2irRKAQbYJMw9L/vIMTMragV
         P0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DnJ87hIg+L1soXqzK+F25qs93DUI2WPEksuGAxLMiCg=;
        b=AujuKOLTjVMfrsm/0pezolefAWLstQa9U+0Ha1WD0QpaiiX7Llqea9U2pQDT8O8eEK
         zViymWElhzZz3lr+kaqqEARAf/VdTkYzLnv1kwioAs58Ja+hzIgFLNxq6wOJ9KtL2Jeb
         uwkhgA0TRm89HXA3D2oBD0amsiUMmMq8uAJNYr/wZ2QB6+wBbXN9FysmzwfwBepwwECi
         vlq/QtZdinMe+5+Q5ANKFpCCPKaLoT7EDutEw0Zsd9R+BwVV/CFMbmZwIy08ngFIrbpw
         FYi9frinr/aMMUKpDxtg2qXaJDlQO5Y0LEOcdHfPXgfmuqkpWFXQVTt8BJWKrcFB3hjZ
         Lk7g==
X-Gm-Message-State: APjAAAUnhwfNhNIt7Vk4Z57Lo8eN8OGUhcEmll2RnXNz9eaDgYT0yuTp
        ZAQS1Kwt9yT2AYqX2gtyN+uWbXFmUwklnnq0WmU=
X-Google-Smtp-Source: APXvYqxmyBlLRondxqnNbPMJl7+HmdFnfXdetIxT6mvbyOG6g+JATnG+njQGRWZouNhBl1mciLaGDoHDt1xiEhZVZeU=
X-Received: by 2002:a2e:974c:: with SMTP id f12mr5309332ljj.15.1567766426819;
 Fri, 06 Sep 2019 03:40:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190906094158.8854-1-streetwalkermc@gmail.com> <20190906101306.GA12017@kadam>
In-Reply-To: <20190906101306.GA12017@kadam>
From:   Dan Elkouby <streetwalkermc@gmail.com>
Date:   Fri, 6 Sep 2019 13:40:15 +0300
Message-ID: <CANnEQ3HX0SNG+Hzs2b+BzLwuewsC8-3sF2urWV+bqUahXq0hVA@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: hidp: Fix error checks in hidp_get/set_raw_report
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabian Henneke <fabian.henneke@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 1:14 PM Dan Carpenter wrote:
> I think we also need to update update ms_ff_worker() which assumes that
> hid_hw_output_report() returns zero on success.

Yes, it looks like that's the case. Should I amend my patch to include
this fix, or should it be a separate patch? I don't have access to any
hardware covered by hid-microsoft, so I won't be able to test it.

> Please use the Fixes
> tag for this since a lot of scripts rely on it to decide what to
> backport.
>
> Fixes: 48d9cc9d85dd ("Bluetooth: hidp: Let hidp_send_message return number of queued bytes")

Will do.

> Otherwise, it looks good.  Thanks for catching this.

Thanks for taking a look!

(Sorry for sending this twice, I'm not used to mailing lists and forgot
to reply to all.)
