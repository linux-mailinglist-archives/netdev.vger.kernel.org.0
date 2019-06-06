Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCCE0375A5
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbfFFNtl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jun 2019 09:49:41 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:37481 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfFFNtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 09:49:40 -0400
Received: by mail-ed1-f65.google.com with SMTP id w13so3461301eds.4
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 06:49:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=j3i5guPNWte923XV713tdz8UcowwZRhCJspDF63SmmQ=;
        b=f4G1R30PbtGY6sgnfYKV+8FIMQZw+1QyyXn8Y4Lgp/WcUgA/DtCjIkBKclRa7lYzw3
         F9eCLIgMYvMECUj3NNxXUR2XIol3ym4W0cMXjJ3vqURYsLdNPw83pPylhoD7DV3TM3bE
         FaWQzKTFfAwWA3ZzmNGvb/fvVcP70G+m6jlpUUETDRy/1QuSodMcPJU5kNvHswnKMPXa
         Hg6l8mddY86oF4UVUPiImeryayR4taq4qOqcEku/2F5D/AIC3gIfUuK8wGRoPIIsT/SC
         tPZomM8Ga1Wy3mY1btp4KTo8k3vUQo0OBnNIL1MGuvO32QkNIVuPrIpyV71hPOOAyTUe
         mkhA==
X-Gm-Message-State: APjAAAX/wYpa3jABQFBj+Dil//Y4p4iiVx7LgfpPWXGj1ts8gJwB54d9
        ndF4ZXymyIc0d8QgUnCz5DfjfA==
X-Google-Smtp-Source: APXvYqxMyjUrS1kr3CkSn3LuoA7uatliZE1O5iz6J4GA3XsVvr/lAA9ZMEXvSj2Q6pfZcBTTfXE2BA==
X-Received: by 2002:a17:906:b743:: with SMTP id fx3mr42181048ejb.208.1559828979194;
        Thu, 06 Jun 2019 06:49:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id fj23sm354100ejb.47.2019.06.06.06.49.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 06:49:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BBC8C181CC1; Thu,  6 Jun 2019 15:49:37 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, brouer@redhat.com
Subject: Re: [PATCH net-next v2 2/2] devmap: Allow map lookups from eBPF
In-Reply-To: <20190606153344.4871ffa2@carbon>
References: <155982745450.30088.1132406322084580770.stgit@alrua-x1> <155982745466.30088.16226777266948206538.stgit@alrua-x1> <20190606153344.4871ffa2@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 06 Jun 2019 15:49:37 +0200
Message-ID: <87zhmuddse.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Thu, 06 Jun 2019 15:24:14 +0200
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> 
>> We don't currently allow lookups into a devmap from eBPF, because the map
>> lookup returns a pointer directly to the dev->ifindex, which shouldn't be
>> modifiable from eBPF.
>> 
>> However, being able to do lookups in devmaps is useful to know (e.g.)
>> whether forwarding to a specific interface is enabled. Currently, programs
>> work around this by keeping a shadow map of another type which indicates
>> whether a map index is valid.
>> 
>> Since we now have a flag to make maps read-only from the eBPF side, we can
>> simply lift the lookup restriction if we make sure this flag is always set.
>
> Nice, I didn't know this was possible.  I like it! :-)

Me neither; discovered it while looking through the verifier code to
figure out what would be needed to get the verifier to enforce read-only
semantics. Not much, as it turned out :)

The functionality was introduced in:
591fe9888d78 ("bpf: add program side {rd, wr}only support for maps") by
Daniel from April 9th.

-Toke
