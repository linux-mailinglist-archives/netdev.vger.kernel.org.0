Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2891FF076
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 13:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgFRLZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 07:25:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43033 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727904AbgFRLZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 07:25:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592479551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B7rSVKZDNp4iswBlCbZr4Q8nxVU2bXiQegcazbH/DEU=;
        b=bcJyVPUCwTxLqqPYVZjHUNg2FHgj9GFeoKYmFJq6INLf7kbwHqTBuzpYYomCwWyZ4/m9pe
        CckQdMaP10k4F3UP74SMlZ803sYZoytsIi8n5aEVqhZDGQiYQvaxI8w3V7DhyCb+HDZUNY
        zAz1HeflkpNmrHW5Kb5tKGJTZ83YpRI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-TS9SHZK-M5Gnexc2ECUIvw-1; Thu, 18 Jun 2020 07:25:49 -0400
X-MC-Unique: TS9SHZK-M5Gnexc2ECUIvw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95FDD106B3BA;
        Thu, 18 Jun 2020 11:25:48 +0000 (UTC)
Received: from new-host-5 (unknown [10.40.193.248])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D7E05D9D3;
        Thu, 18 Jun 2020 11:25:46 +0000 (UTC)
Message-ID: <70911c86d54033c956cb06593858f6e0111eb58a.camel@redhat.com>
Subject: Re: [PATCH iproute2] tc: m_tunnel_key: fix geneve opt output
From:   Davide Caratti <dcaratti@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     lucien.xin@gmail.com, Simon Horman <simon.horman@netronome.com>,
        Stephen Hemminger <stephen@networkplumber.org>
In-Reply-To: <20200618104420.499155-1-liuhangbin@gmail.com>
References: <20200618104420.499155-1-liuhangbin@gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 18 Jun 2020 13:25:46 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-18 at 18:44 +0800, Hangbin Liu wrote:
> Commit f72c3ad00f3b changed the geneve option output from "geneve_opt"
> to "geneve_opts", which may break the program compatibility. Reset
> it back to geneve_opt.
> 
> Fixes: f72c3ad00f3b ("tc: m_tunnel_key: add options support for vxlan")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tc/m_tunnel_key.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
> index bfec9072..0074f744 100644
> --- a/tc/m_tunnel_key.c
> +++ b/tc/m_tunnel_key.c
> @@ -534,7 +534,7 @@ static void tunnel_key_print_geneve_options(struct rtattr *attr)
>  	struct rtattr *i = RTA_DATA(attr);
>  	int ii, data_len = 0, offset = 0;
>  	int rem = RTA_PAYLOAD(attr);
> -	char *name = "geneve_opts";
> +	char *name = "geneve_opt";
>  	char strbuf[rem * 2 + 1];
>  	char data[rem * 2 + 1];
>  	uint8_t data_r[rem];

... by the way, this patch does not look good to me. It fixes program
compatibility for 

# tc action show 

but at the same time, I think it breaks program compatibility for

# tc -j action show

see below: looking at commit f72c3ad00f3b,

 static void tunnel_key_print_tos_ttl(FILE *f, char *name,
@@ -519,8 +586,7 @@ static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
                                        tb[TCA_TUNNEL_KEY_ENC_KEY_ID]);
                tunnel_key_print_dst_port(f, "dst_port",
                                          tb[TCA_TUNNEL_KEY_ENC_DST_PORT]);
-               tunnel_key_print_key_opt("geneve_opts",
-                                        tb[TCA_TUNNEL_KEY_ENC_OPTS]);
+               tunnel_key_print_key_opt(tb[TCA_TUNNEL_KEY_ENC_OPTS])

here "name" was "geneve_opts", with the 's', and it was used here:

		open_json_array(PRINT_JSON, name);

so, the proper way to restore script compatibility is to do something
like:

-	print_string(PRINT_FP, name, "\t%s ", name);
+	print_string(PRINT_FP, NULL, "\t%s ", "geneve_opt");

yes, we can "harmonize" like Simon proposed, but then the fix in the
(currently broken) tdc test case should accept both 'geneve_opts' and
'geneve_opt'. Something similar has been done in the past for act_ife 
see net.git commit 91fa038d9446 ("selftests: tc-testing: fix parsing of
ife type").

-- 
davide


