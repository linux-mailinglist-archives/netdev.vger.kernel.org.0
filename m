Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5130E3F0310
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhHRLzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:55:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45651 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231476AbhHRLzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 07:55:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629287684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aF2YAaaZplhykzZP8JKiNx+F3piFPmPM20xDcdTGrrE=;
        b=UR/OQLPubR7r25MUHTfzJEzAuodZFkmhRbwKr2mdQ7A++KSFZgZ6C1uiEJfgYqdpvd73N2
        KkavuB3rixBglxEhU25R58UVGxAPQlryC3wFgf4P0bP/tBwqwstETIEt26K5QRfnxuEo+X
        ARDdmvzOI1pnXfPw2O0JR1LVKSGBzN0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-OKj-mQDFPd27Iv1NRX9yRg-1; Wed, 18 Aug 2021 07:54:43 -0400
X-MC-Unique: OKj-mQDFPd27Iv1NRX9yRg-1
Received: by mail-wm1-f71.google.com with SMTP id j33-20020a05600c1c21b02902e6828f7a20so673508wms.7
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 04:54:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:to:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=aF2YAaaZplhykzZP8JKiNx+F3piFPmPM20xDcdTGrrE=;
        b=qEPzfLGumI3hs4nGmyooPITc86izzzzbnHZgTt6tVwlGy9if2ZhW6wsCDTN1fToEfr
         n0FnAmVQz3x4wGzJEUwGlUvXqiul64Ybexd47Pxlbo9SV04jxRBxOSmliiRw9Z+AMao3
         5DPwAqOPGTVDd2CLvaJrstb5bOwjLvCfxbs3OMNiNbeKimtejfv9SWhheGDSwEhTMPI1
         YZGDLyOFQ6e1ceXTRqlxchnzIfZSsXccFa81lKHYo39aMZ8Tb7yqwltJOR4k/K9OV+Va
         uZdnFZsr0N+b0N4vcQUsmbnlxV2hccXJP3zojkaY/5E5Wosp1ce6Fkytzt2ORdcF88Ff
         cMBg==
X-Gm-Message-State: AOAM530BxHMcwX/3gJv3FHEgXmrzsNuR5vlxbZmek3n2aQ3jTGk0rzXt
        xh8rf+MFr+GK5PWTf35IuA2JN8+Tg7q7lgBV0jzYMNHzrcyQRH9VBAuijn8xt7gR2guDp5uYrUE
        FWUbx092DyvYsvbNOVmFrnGacd6uSk4raxn8TZ1Y4PfPFCLQBKHSww4Fy1k0f9Lqv5dA=
X-Received: by 2002:adf:d227:: with SMTP id k7mr10062277wrh.285.1629287681728;
        Wed, 18 Aug 2021 04:54:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4Cihy/hZE7IlAomO9N7U5eaYxYs2uFifO8eMnZkuiaHLF8ULquzCUmRu2+HmnlR24dHbuXg==
X-Received: by 2002:adf:d227:: with SMTP id k7mr10062256wrh.285.1629287681579;
        Wed, 18 Aug 2021 04:54:41 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id o8sm2794321wmq.21.2021.08.18.04.54.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 04:54:41 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
To:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Kishen Maloor <kishen.maloor@intel.com>,
        "Desouza, Ederson" <ederson.desouza@intel.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: AF_XDP finding descriptor room for XDP-hints metadata size
Message-ID: <811eb35f-5c8b-1591-1e68-8856420b4578@redhat.com>
Date:   Wed, 18 Aug 2021 13:54:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


In previous discussions with AF_XDP maintainers (Magnus+Bjørn), I 
understood we have two challenges with metadata and BTF id.

  (1) AF_XDP doesn't know size of metadata area.
  (2) No room in xdp_desc to store the BTF-id.

Below I propose new idea to solve (1) metadata size.

To follow the discussion this is struct xdp_desc:

  /* Rx/Tx descriptor */
  struct xdp_desc {
	__u64 addr;
	__u32 len;
	__u32 options;
  };

One option (that was rejected) was to store the BTF-id in 'options' and
deduct the metadata size from BTF-id, but it was rejected as it blocks
future usages of 'options'.

The proposal by Magnus was to use a single bit in 'options' to say this
descriptor contains metadata described via BTF info. And Bjørn proposed
to store the BTF-id as the last member in metadata, as it would be
accessible via minus-4 byte offset from packet start 'addr'. And again
via BTF-id code can know the size of metadata area.

My idea is that we could store the metadata size in top-bits of 'len'
member when we have set the 'options' bit for BTF-metadata.

-Jesper

