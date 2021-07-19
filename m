Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C633CD4A3
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 14:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236664AbhGSLle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 07:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236427AbhGSLld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 07:41:33 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23813C061574
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 04:38:00 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id b26so29864804lfo.4
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 05:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=/Lr4bHKOUY9u5zZ0KopUgP5BWr01yWcUC6XsKm78Wf0=;
        b=RhfSBCMgmnurUPlehfuYlkq+nhGGQy9RnOPdfXFUdExKFplbtvb5meAMOeqRb8KzlR
         CXYTuzndP44H6GYM6o7brlGQcZWTRbTaX9fhQbCilagqi3QZsZM+0/nB219/wGaM0dtb
         hH7LT4IQdwfME8q0pIYvYCu7GZpg/AKpB1HbFAMf1ok/gZosj9wJSfpvSqi5kiC6YguJ
         lLG/8D2PdftbM1OcynGhp1GlXddWfkrMhGnfbd4LpLLrSdHsrckl/aqV39n6TZhqdAik
         4NopQN1f7KcVTZi6/VayHMt6XN0HMoyrsqzQ2N/+sYqfwtC48kTzKBImHSJlyFsSIQE5
         9HOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=/Lr4bHKOUY9u5zZ0KopUgP5BWr01yWcUC6XsKm78Wf0=;
        b=HiVg9ufRNd+v4drIehB9knOqlsDuovZpmfwuEYWQkHfQSBFNya8Cu+nEDr/W9yv2AL
         CdVrYilf1ph35L7Crvw5tjPRJN53E1SwurouDsBKbifHYjyMPnBDZaRM6cfGVQw0vxWm
         hvnBJb2ixK8vSJyWRRAIK36VynngFv7hZ/ei8JYmCxH7SY5kOWI4qvT8ny3h3PxzIdZa
         LiSSoZ0oaipJc2c5rkckk2xIpJfH7FKQHYpf0u7iLKfXeYSc1klFud8PMo+Fzdtjb1Xt
         Opw8DjMx2Swo+9unyCaWxPhYfouebmuzf/zgdONj62VrAQ5oq8Inm71T8dfK7gsPenDv
         uDow==
X-Gm-Message-State: AOAM5304VA77hJNiaTGlLGjbEhpIWXTx7ujI2eROQvuyGKh02qVqsBHq
        o2T/f4kQ2DhfJmSyCMwmfMQWOSxsPvxBl17T87x6eMF8U2KF+U1z
X-Google-Smtp-Source: ABdhPJxgbJRvYFIcIdez/08IHxQbxnY+CVoC5vWsGdeT9dDOKXKUic/i+wU6tSKOySt3ikOWZ7t0D+5itWp87qVRKMs=
X-Received: by 2002:a05:6512:3148:: with SMTP id s8mr17635889lfi.513.1626697331465;
 Mon, 19 Jul 2021 05:22:11 -0700 (PDT)
MIME-Version: 1.0
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Mon, 19 Jul 2021 20:22:01 +0800
Message-ID: <CALW65jZoaYYycAApviuQjiOTNuG9sfSpGZ1izRgJhj4M-gfDyQ@mail.gmail.com>
Subject: DSA .port_{f,m}db_{add,del} with offloaded LAG interface on mv88e6xxx
To:     netdev <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

What happens if a FDB entry is added manually to an offloaded LAG
interface? Does DSA core simply call .port_fdb_add with the member
ports in the LAG?

I'm asking because there is a trunk field in struct
mv88e6xxx_atu_entry, when it is true, the portvec is actually the
trunk ID.
As the current implementation (mv88e6xxx_port_db_load_purge) does not
use this field, it probably won't work.

Regards,
Qingfang
