Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984786A584D
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 12:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjB1LeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 06:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbjB1LeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 06:34:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD751715
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 03:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677584003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Td4oddmmM1+vJS0lWsyO8iL6ac/jcvqUOESFVNQcxyQ=;
        b=I+Ah4p2bZfyQjJDkOpkxzhfZXkO3z3FJz/Pqje8kLnMXFXhOdgS1anAVhRZSZ6zUq11uVO
        r/McgOJkE5ckuF1L3lR5vnIybO3k2f5yvxBIE2u9B7k4cZn++E6bIrNSUiRjSsmOCuSr/8
        TRcMIFdlR/9jW7CPeg2cV1GT9eERkKY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-597-2mt5DN-BPw6CCClEr1h8WA-1; Tue, 28 Feb 2023 06:33:21 -0500
X-MC-Unique: 2mt5DN-BPw6CCClEr1h8WA-1
Received: by mail-wr1-f69.google.com with SMTP id bt1-20020a056000080100b002c557db0e0fso1493749wrb.11
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 03:33:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Td4oddmmM1+vJS0lWsyO8iL6ac/jcvqUOESFVNQcxyQ=;
        b=p7WvQnJoIbqpdbnoJufjzwaqqdmyFjw9h5P3cxenW6J/pe3USckaPBfWR9dJvElS/M
         q1Aqm9K54NEjX3JwBDJomQL0MVqw93JGia642sCNDK9FWE9+2swD1PFj8/hCBiGCru9y
         OVYqgJHiTW2smeg4zZt7kahp+C5B+LEHmSDmDKrb9Uy2MG2GrYusZG09fVpp5LwCPeh+
         utm7GQOo5QhL1E19vS/RZl3JH+huo2sATR3oBY7+NUmFRyNiVTSQigxaGoLPj+77X2oz
         ntJPI/gnZPPlSnTiaEpMl5vhRCJ3Rb1EC8BhM02tmsdRp898sfbuBCnA9tF7mAewlNcw
         6mqg==
X-Gm-Message-State: AO0yUKUeus7Jp83pFsZHV9Z+SClNRJzj9Djaz1vYpzG8mCv8kwttPXh1
        yTioDVcuUi3Iv4y6yWRPKaszCo4qHplGokQHkCxA6GF9z/nKHlRFgI8U6td87hBVPJTiW0NyDhH
        +jNan/OVvddbl/X0M
X-Received: by 2002:a5d:5962:0:b0:2c9:8b81:bd04 with SMTP id e34-20020a5d5962000000b002c98b81bd04mr1569315wri.0.1677584000916;
        Tue, 28 Feb 2023 03:33:20 -0800 (PST)
X-Google-Smtp-Source: AK7set9Q9kIQxqyRlatsve8g0wcgxyegweDnlQJHTOCP2QArZXsRYiS2XU5fqY0HFcUTe47lj7xTDw==
X-Received: by 2002:a5d:5962:0:b0:2c9:8b81:bd04 with SMTP id e34-20020a5d5962000000b002c98b81bd04mr1569305wri.0.1677584000626;
        Tue, 28 Feb 2023 03:33:20 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id c18-20020adfed92000000b002c54c9bd71fsm9793687wro.93.2023.02.28.03.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 03:33:19 -0800 (PST)
Message-ID: <4a10c2acacf8ca3e34c5452c44fe21bbcc26e271.camel@redhat.com>
Subject: Re: [PATCH net 0/7] mptcp: fixes for 6.3
From:   Paolo Abeni <pabeni@redhat.com>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>,
        Jiang Biao <benbjiang@tencent.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, stable@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>,
        Geliang Tang <geliang.tang@suse.com>
Date:   Tue, 28 Feb 2023 12:33:17 +0100
In-Reply-To: <a0a76c20-4fd9-476b-3e32-06f7cc2bbf1b@tessares.net>
References: <20230227-upstream-net-20230227-mptcp-fixes-v1-0-070e30ae4a8e@tessares.net>
         <a0a76c20-4fd9-476b-3e32-06f7cc2bbf1b@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-28 at 12:28 +0100, Matthieu Baerts wrote:
> Hello,
>=20
> On 27/02/2023 18:29, Matthieu Baerts wrote:
> > Patch 1 fixes a possible deadlock in subflow_error_report() reported by
> > lockdep. The report was in fact a false positive but the modification
> > makes sense and silences lockdep to allow syzkaller to find real issues=
.
> > The regression has been introduced in v5.12.
> >=20
> > Patch 2 is a refactoring needed to be able to fix the two next issues.
> > It improves the situation and can be backported up to v6.0.
> >=20
> > Patches 3 and 4 fix UaF reported by KASAN. It fixes issues potentially
> > visible since v5.7 and v5.19 but only reproducible until recently
> > (v6.0). These two patches depend on patch 2/7.
> >=20
> > Patch 5 fixes the order of the printed values: expected vs seen values.
> > The regression has been introduced recently: present in Linus' tree but
> > not in a tagged version yet.
> >=20
> > Patch 6 adds missing ro_after_init flags. A previous patch added them
> > for other functions but these two have been missed. This previous patch
> > has been backported to stable versions (up to v5.12) so probably better
> > to do the same here.
> >=20
> > Patch 7 fixes tcp_set_state() being called twice in a row since v5.10.
>=20
> I'm sorry to ask for that but is it possible not to apply these patches?

Done, thanks!

Paolo

