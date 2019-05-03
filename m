Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0AA312D24
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 14:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfECMGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 08:06:08 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:45922 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfECMGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 08:06:08 -0400
Received: by mail-yw1-f67.google.com with SMTP id w18so4055477ywa.12
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 05:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=40wRrhx/Trq/1XYyPnxYud36gRUu/B5cvvMNQdkmAYA=;
        b=EO0+ynRilAN+QOxxe6WTaRDl1FqCsueUAk5ykW8nx7nElZFmXYF1oCM66ij2mULF1c
         EcTEi5ygthwy3Gulisj0g0H0eq92SozYYek5TXSHri8+RGPEAm/KsG1uw8ePGKSM8Twp
         qu+E+nVBwtD3GFJgABbMExCYIyq/WfS9yFR4XXSjD7K93nfuE8t8GSviUV5O+A6lZEiq
         M2pyhMSedNTmJfTh81yXfc5mPGpVBBdxY+sYV3XmW/kBexZkA558CKIj3jmff91/LIjz
         wqPTC/x6wL5/ai4t2+g3NvyEHBIRZ7HROEGRBWtUSkztpnXPTRe4bi2YrWVEFRwq1QmM
         jTgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=40wRrhx/Trq/1XYyPnxYud36gRUu/B5cvvMNQdkmAYA=;
        b=QnjdaRrwbqDlkfE/IX+Q3CWxtfRUIQ6+mcXz6Cnvq72JZJjS/rVpYM7IWix5KzIlmc
         BRsQMCNNYH+dgMkBkkDBqNtNwKDjMkwHkpdwRjAb8AgcQWuhihWb+pLXYxdMp/8P3Usi
         /Eu6PdPBsfpK8uC6BnPBR/H2tSrI35zHP/ybzPQwhrF0azCQhsiCqgz+66sC9MBmCHnp
         Qo7OOTlE8L/qo6wxpNI0G/YxWFtKzccnubZA6WutcelTkYBuPZInEB3G7NJ1758XNyEb
         C4qLMokyGpuZkajznHztRbtm63aPX1v55DQx7kJm2awWFxwJD3qFkTgAnHKb/lfFFQhD
         IJ8Q==
X-Gm-Message-State: APjAAAUjy9+L0uhs7DsCtavyuMiM09/uVUBA2/6GBhD5l6Kc0XKiSk8x
        BQLuBsem4KWX165crVpBKmds4IQg
X-Google-Smtp-Source: APXvYqyFsvx9mdRpKuAKpV6IZF3LYSZ+0YC5fYxvVWXSDkOnn0NrWITHjJNtk2GnH0YL+TD1Si1pFw==
X-Received: by 2002:a81:4f94:: with SMTP id d142mr7566675ywb.376.1556885167575;
        Fri, 03 May 2019 05:06:07 -0700 (PDT)
Received: from [172.20.0.54] (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id p3sm626541ywf.2.2019.05.03.05.06.06
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 05:06:06 -0700 (PDT)
Subject: Re: [RFC HACK] xfrm: make state refcounting percpu
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Florian Westphal <fw@strlen.de>
Cc:     vakul.garg@nxp.com, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
References: <20190423162521.sn4lfd5iia566f44@breakpoint.cc>
 <20190424104023.10366-1-fw@strlen.de>
 <20190503060748.GK17989@gauss3.secunet.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0b998948-d89f-21bf-f76a-9c2b96dffd1d@gmail.com>
Date:   Fri, 3 May 2019 08:06:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503060748.GK17989@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/19 2:07 AM, Steffen Klassert wrote:
> On Wed, Apr 24, 2019 at 12:40:23PM +0200, Florian Westphal wrote:
>> I'm not sure this is a good idea to begin with, refcount
>> is right next to state spinlock which is taken for both tx and rx ops,
>> plus this complicates debugging quite a bit.
> 
> 


For some reason I have not received Florian response.

Florian, when the percpu counters are in nominal mode,
the updates are only in percpu memory, so the cache line containing struct percpu_ref in the
main object is not dirtied.

(This field/object can be placed in a read-mostly location of the structure if needed)

I would definitely try to use this.
