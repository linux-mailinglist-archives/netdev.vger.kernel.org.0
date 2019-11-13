Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0EE2FB99B
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfKMUVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:21:33 -0500
Received: from ozlabs.org ([203.11.71.1]:39451 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbfKMUVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 15:21:33 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47CwxN3QpGz9sP3;
        Thu, 14 Nov 2019 07:21:28 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1573676489;
        bh=cqdhA1GeUnwdtRyeU+v2vCtRwjGGl9JmaH/BSlxeAUU=;
        h=Date:From:To:Cc:Subject:From;
        b=HGNxW8kKyzAHe3qeZib0aVg7+e+tJaDO46mWktPdydbVQMXsqOm6MGdo9eaLK9Yf3
         Ka6vTYSOpwtS80zM1DigfFsBjSGwh4D7zDNfy1BhfrpRXvjj+zSpytxe1drFioA+SE
         w8emrMAWEMDxPy/iUQEaUn26Z5KhBdfjTffJ2iUPYUSZjUBDkURkNTV2KKKJDg/HyG
         Im2Kxh5pvaw23uAFPcCVhFQfvDkDPkfcmtOHa6jCaJ5lzJ8EXmiZ+rIqFhNS5jTWxl
         IsW8alWAPQbR17XGXwKgbLCRy9AUXGvRUe58IxmN3dn4v/cLF305FkDHXZJ6ODbSdC
         vi8GL2OS74B9A==
Date:   Thu, 14 Nov 2019 07:21:20 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20191114072120.505dcb59@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qT.g2TIBVnLNH.MDe3tItZQ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/qT.g2TIBVnLNH.MDe3tItZQ
Content-Type: multipart/mixed; boundary="MP_/JK.BRX0v6NlJ_9YjZwq/T3/"

--MP_/JK.BRX0v6NlJ_9YjZwq/T3/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi all,

Commits

  4a15d574e68a ("can: j1939: warn if resources are still linked on destroy")
  ddeeb7d4822e ("can: j1939: j1939_can_recv(): add priv refcounting")
  8d7a5f000e23 ("can: j1939: transport: j1939_cancel_active_session(): use =
hrtimer_try_to_cancel() instead of hrtimer_cancel()")
  62ebce1dc1fa ("can: j1939: make sure socket is held as long as session ex=
ists")
  d966635b384b ("can: j1939: transport: make sure the aborted session will =
be deactivated only once")
  fd81ebfe7975 ("can: j1939: socket: rework socket locking for j1939_sk_rel=
ease() and j1939_sk_sendmsg()")
  c48c8c1e2e81 ("can: j1939: main: j1939_ndev_to_priv(): avoid crash if can=
_ml_priv is NULL")
  25fe97cb7620 ("can: j1939: move j1939_priv_put() into sk_destruct callbac=
k")
  975987e7015b ("can: af_can: export can_sock_destruct()")

are missing a Signed-off-by from their committer.

Dave, since your trees are immutable, you are really going to have to
do some premerge checking for these ... I have attached the scripts I
use.  Others have some git hooks which do something similar.

--=20
Cheers,
Stephen Rothwell

--MP_/JK.BRX0v6NlJ_9YjZwq/T3/
Content-Type: application/x-shellscript
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=check_commits

#!/bin/bash

if [ "$#" -lt 1 ]; then
	printf 'Usage: %s <commit range>\n' "$0" 1>&2
	exit 1
fi

commits=3D$(git rev-list --no-merges "$@")
if [ -z "$commits" ]; then
	printf 'No commits\n'
	exit 0
fi

"$(realpath "$(dirname "$0")")/check_fixes" "$@"

declare -a author_missing committer_missing

print_commits()
{
	if [ "$#" -eq 1 ]; then
		return
	fi

	local t=3D"$1"

	shift

	s=3D
	is=3D'is'
	its=3D'its'
	if [ "$#" -gt 1 ]; then
		s=3D's'
		is=3D'are'
		its=3D'their'
	fi
	printf 'Commit%s\n\n' "$s"
	git log --no-walk --pretty=3D'format:  %h ("%s")' "$@"
	printf '\n%s missing a Signed-off-by from %s %s%s.\n\n' \
		"$is" "$its" "$t" "$s"
}

check_unexpected_files()
{
	local files

	readarray files < <(git diff-tree -r --diff-filter=3DA --name-only --no-co=
mmit-id "$1" '*.rej' '*.orig')
	if [ "${#files[@]}" -eq 0 ]; then
		return
	fi

	s=3D
	this=3D'this'
	if [ "${#files[@]}" -gt 1 ]; then
		s=3D's'
		this=3D'these'
	fi

	printf 'Commit\n\n'
	git log --no-walk --pretty=3D'format:  %h ("%s")' "$1"
	printf '\nadded %s unexpected file%s:\n\n' "$this" "$s"
	printf '  %s\n' "${files[@]}"
}

for c in $commits; do
	ae=3D$(git log -1 --format=3D'<%ae>%n<%aE>%n %an %n %aN ' "$c" | sort -u)
	ce=3D$(git log -1 --format=3D'<%ce>%n<%cE>%n %cn %n %cN ' "$c" | sort -u)
	sob=3D$(git log -1 --format=3D'%b' "$c" |
		sed -En 's/^\s*Signed-off-by:?\s*/ /ip')

	if ! grep -i -F -q "$ae" <<<"$sob"; then
		author_missing+=3D("$c")
	fi
	if ! grep -i -F -q "$ce" <<<"$sob"; then
		committer_missing+=3D("$c")
	fi

	check_unexpected_files "$c"
done

print_commits 'author' "${author_missing[@]}"
print_commits 'committer' "${committer_missing[@]}"

exec gitk "$@"

--MP_/JK.BRX0v6NlJ_9YjZwq/T3/
Content-Type: application/x-shellscript
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=check_fixes

#!/bin/bash

if [ "$#" -lt 1 ]; then
        printf 'Usage: %s <commit range>\n', "$0" 1>&2
        exit 1
fi

commits=3D$(git rev-list --no-merges -i --grep=3D'^[[:space:]]*Fixes:' "$@")
if [ -z "$commits" ]; then
        exit 0
fi

# This should be a git tree that contains *only* Linus' tree
Linus_tree=3D"${HOME}/kernels/linus.git"

split_re=3D'^([Cc][Oo][Mm][Mm][Ii][Tt])?[[:space:]]*([[:xdigit:]]{5,})([[:s=
pace:]]*)(.*)$'
nl=3D$'\n'
tab=3D$'\t'

# Strip the leading and training spaces from a string
strip_spaces()
{
	[[ "$1" =3D~ ^[[:space:]]*(.*[^[:space:]])[[:space:]]*$ ]]
	echo "${BASH_REMATCH[1]}"
}

for c in $commits; do

	commit_log=3D$(git log -1 --format=3D'%h ("%s")' "$c")
	commit_msg=3D"In commit

  $commit_log

"

	fixes_lines=3D$(git log -1 --format=3D'%B' "$c" |
			grep -i '^[[:space:]]*Fixes:')

	while read -r fline; do
		[[ "$fline" =3D~ ^[[:space:]]*[Ff][Ii][Xx][Ee][Ss]:[[:space:]]*(.*)$ ]]
		f=3D"${BASH_REMATCH[1]}"
		fixes_msg=3D"Fixes tag

  $fline

has these problem(s):

"
		sha=3D
		subject=3D
		msg=3D
		if [[ "$f" =3D~ $split_re ]]; then
			first=3D"${BASH_REMATCH[1]}"
			sha=3D"${BASH_REMATCH[2]}"
			spaces=3D"${BASH_REMATCH[3]}"
			subject=3D"${BASH_REMATCH[4]}"
			if [ "$first" ]; then
				msg=3D"${msg:+${msg}${nl}}  - leading word '$first' unexpected"
			fi
			if [ -z "$subject" ]; then
				msg=3D"${msg:+${msg}${nl}}  - missing subject"
			elif [ -z "$spaces" ]; then
				msg=3D"${msg:+${msg}${nl}}  - missing space between the SHA1 and the su=
bject"
			fi
		else
			printf '%s%s  - %s\n' "$commit_msg" "$fixes_msg" 'No SHA1 recognised'
			commit_msg=3D''
			continue
		fi
		if ! git rev-parse -q --verify "$sha" >/dev/null; then
			printf '%s%s  - %s\n' "$commit_msg" "$fixes_msg" 'Target SHA1 does not e=
xist'
			commit_msg=3D''
			continue
		fi

		if [ "${#sha}" -lt 12 ]; then
			msg=3D"${msg:+${msg}${nl}}  - SHA1 should be at least 12 digits long${nl=
}    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11$=
{nl}    or later) just making sure it is not set (or set to \"auto\")."
		fi
		# reduce the subject to the part between () if there
		if [[ "$subject" =3D~ ^\((.*)\) ]]; then
			subject=3D"${BASH_REMATCH[1]}"
		elif [[ "$subject" =3D~ ^\((.*) ]]; then
			subject=3D"${BASH_REMATCH[1]}"
			msg=3D"${msg:+${msg}${nl}}  - Subject has leading but no trailing parent=
heses"
		fi

		# strip matching quotes at the start and end of the subject
		# the unicode characters in the classes are
		# U+201C LEFT DOUBLE QUOTATION MARK
		# U+201D RIGHT DOUBLE QUOTATION MARK
		# U+2018 LEFT SINGLE QUOTATION MARK
		# U+2019 RIGHT SINGLE QUOTATION MARK
		re1=3D$'^[\"\u201C](.*)[\"\u201D]$'
		re2=3D$'^[\'\u2018](.*)[\'\u2019]$'
		re3=3D$'^[\"\'\u201C\u2018](.*)$'
		if [[ "$subject" =3D~ $re1 ]]; then
			subject=3D"${BASH_REMATCH[1]}"
		elif [[ "$subject" =3D~ $re2 ]]; then
			subject=3D"${BASH_REMATCH[1]}"
		elif [[ "$subject" =3D~ $re3 ]]; then
			subject=3D"${BASH_REMATCH[1]}"
			msg=3D"${msg:+${msg}${nl}}  - Subject has leading but no trailing quotes"
		fi

		subject=3D$(strip_spaces "$subject")

		target_subject=3D$(git log -1 --format=3D'%s' "$sha")
		target_subject=3D$(strip_spaces "$target_subject")

		# match with ellipses
		case "$subject" in
		*...)	subject=3D"${subject%...}"
			target_subject=3D"${target_subject:0:${#subject}}"
			;;
		...*)	subject=3D"${subject#...}"
			target_subject=3D"${target_subject: -${#subject}}"
			;;
		*\ ...\ *)
			s1=3D"${subject% ... *}"
			s2=3D"${subject#* ... }"
			subject=3D"$s1 $s2"
			t1=3D"${target_subject:0:${#s1}}"
			t2=3D"${target_subject: -${#s2}}"
			target_subject=3D"$t1 $t2"
			;;
		esac
		subject=3D$(strip_spaces "$subject")
		target_subject=3D$(strip_spaces "$target_subject")

		if [ "$subject" !=3D "${target_subject:0:${#subject}}" ]; then
			msg=3D"${msg:+${msg}${nl}}  - Subject does not match target commit subje=
ct${nl}    Just use${nl}${tab}git log -1 --format=3D'Fixes: %h (\"%s\")'"
		fi
		lsha=3D$(cd "$Linus_tree" && git rev-parse -q --verify "$sha")
		if [ -z "$lsha" ]; then
			count=3D$(git rev-list --count "$sha".."$c")
			if [ "$count" -eq 0 ]; then
				msg=3D"${msg:+${msg}${nl}}  - Target is not an ancestor of this commit"
			fi
		fi
		if [ "$msg" ]; then
			printf '%s%s%s\n' "$commit_msg" "$fixes_msg" "$msg"
			commit_msg=3D''
		fi
	done <<< "$fixes_lines"
done

exit 0

--MP_/JK.BRX0v6NlJ_9YjZwq/T3/--

--Sig_/qT.g2TIBVnLNH.MDe3tItZQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3MZcAACgkQAVBC80lX
0Gy6/Af/bC3OqDtFAQ6sBwBr3KME8BhaE/vjn9zmx7WISP1/95DBUP2eQLH71DBr
D6Bts+D6lsIH2Zlxb/ZSBxMukV+fsp9EjWOeEmVH/K09/QwNuDNLHTrh+OJpwqUc
ph/vKsIWmRQ6eha60ll2cC8araV3M+JkDCKdYONkZ9kzqNWkAfx7o/kpfA1DvEFd
mlMD1f7YIliViyeVO9GGgJNM2tf4csIfW97LbKCyyOJeD9NqHCkQmzxYLJ/do1w7
TK/N5dDrteF5nbofU78v1J/AMr2PyPoflyxHNDrJ9Yrkren5daYiaevzQVzpczIw
cddA712FK2u24sz2D6YrLf21TvhGaw==
=DL7n
-----END PGP SIGNATURE-----

--Sig_/qT.g2TIBVnLNH.MDe3tItZQ--
