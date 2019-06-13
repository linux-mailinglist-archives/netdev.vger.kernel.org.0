Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C18943C97
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732596AbfFMPg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:36:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727143AbfFMKRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 06:17:09 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7D66530F1BA8;
        Thu, 13 Jun 2019 10:17:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C5DC52FD0;
        Thu, 13 Jun 2019 10:16:59 +0000 (UTC)
Message-ID: <a08bde08fce26054754172786ced8bd671079833.camel@redhat.com>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
From:   Davide Caratti <dcaratti@redhat.com>
To:     Paul Blakey <paulb@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Rony Efraim <ronye@mellanox.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
In-Reply-To: <1560259713-25603-2-git-send-email-paulb@mellanox.com>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
         <1560259713-25603-2-git-send-email-paulb@mellanox.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 13 Jun 2019 12:16:59 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 13 Jun 2019 10:17:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello Paul!

On Tue, 2019-06-11 at 16:28 +0300, Paul Blakey wrote:

> +#endif /* __NET_TC_CT_H */
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index a93680f..c5264d7 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -83,6 +83,7 @@ enum {
>  #define TCA_ACT_SIMP 22
>  #define TCA_ACT_IFE 25
>  #define TCA_ACT_SAMPLE 26
> +#define TCA_ACT_CT 27

^^  I think you can't use 27 (act_ctinfo forgot to explicitly define it),
or the uAPI will break. See below:

>  /* Action type identifiers*/
>  enum tca_id {
> @@ -106,6 +107,7 @@ enum tca_id {
>  	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
>  	/* other actions go here */
>  	TCA_ID_CTINFO,
> +	TCA_ID_CT,
>  	__TCA_ID_MAX = 255
>  };

and (minor ntit) the comment 

/* other actions go here */

should be interpreted like 

/* other actions go right above this comment */

otherwise the comment will float up as we continue adding new TC actions.

After your patch CTinfo and CT will have the same ID:

[dcaratti@localhost tmp.j4kzBzv3oe]$ cat prova.c 
#include <stdio.h>

#define UNO 1
#define DUE 2
#define TRE 3
#define QUATTRO 4

enum {
        TCA_ID_UNO = UNO,
        TCA_ID_DUE = DUE,
        TCA_ID_TRE = TRE,
        TCA_ID_CTINFO,
        TCA_ID_QUATTRO = QUATTRO,
        TCA_ID_MAX
};

int main (int argc, const char *argv[])
{
        printf("%d %d %d %d %d %d\n", TCA_ID_UNO, TCA_ID_DUE, TCA_ID_TRE,
TCA_ID_CTINFO, TCA_ID_QUATTRO, TCA_ID_MAX);
        return 0;
}
[dcaratti@localhost tmp.j4kzBzv3oe]$ gcc prova.c -o prova
[dcaratti@localhost tmp.j4kzBzv3oe]$ ./prova 
1 2 3 4 4 5
[dcaratti@localhost tmp.j4kzBzv3oe]$ 

so, I think you should use 28. And I will send a patch for net-next now
that adds the missing define for TCA_ID_CTINFO. Ok?

-- 
davide

